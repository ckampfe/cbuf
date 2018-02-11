defmodule Cbuf.Map do
  @moduledoc """
  `Cbuf.Map` implements the `Cbuf` behaviour with a `Map` as its implementation.

  For examples of typical use, see the documentation for `new/1`, `insert/2`, `peek/1`, and `delete/1`.

  Operations that must interact with the actual data of the buffer
  (`new/1`, `insert/2`, `peek/1`, `pop/1`, `delete/1`, `to_list/1`, `member?/2`),
  perform as well as `Map` does. This is good, as `Map` is fast.

  Maps, like the other normal Elixir/Erlang datastructures, typically exist in process memory. For example,
  it is recommended to use this module behind a GenServer in order to share its usage across the system.
  Using `Cbuf.Map` in this way means that updates to the buffer will be at the mercy of the process' garbage collection.
  For large data sets with a lot of process GC, [your application may benefit from a different approach](https://elixirforum.com/t/why-use-ets-when-not-to-use-it/4326/8). For this reason, there is also `Cbuf.ETS` that is drop-in API compatible.
  I recommend defaulting to using `Cbuf.Map` with a GenServer and benchmarking your application.

  An example partially-complete `GenServer`  might look something like the following:

  ```
  defmodule EventTracker do
    use GenServer
    alias Cbuf.Map, as: Cbuf

    def start_link(opts) do
      GenServer.start_link(__MODULE__, opts, name: __MODULE__)
    end

    def init(_args) do
      {:ok, nil}
    end

    ###########
    ### API ###
    ###########

    def new(n) do
      GenServer.call(__MODULE__, {:new, n})
    end

    def insert(val) do
      GenServer.call(__MODULE__, {:insert, val})
    end

    def insert_async(val) do
      GenServer.cast(__MODULE__, {:insert, val})
    end

    def peek do
      GenServer.call(__MODULE__, :peek)
    end

    def pop do
      GenServer.call(__MODULE__, :pop)
    end

    #################
    ### CALLBACKS ###
    #################

    ## handle_call

    def handle_call({:new, n}, _from, _state) do
      buf = Cbuf.new(n)

      {:reply, :ok, buf}
    end

    def handle_call({:insert, val}, _from, buf) do
      new_buf = Cbuf.insert(buf, val)

      {:reply, :ok, new_buf}
    end

    def handle_call(:peek, _from, buf) do
      val = Cbuf.peek(buf)

      {:reply, val, buf}
    end

    def handle_call(:pop, _from, buf) do
      {val, new_buf} = Cbuf.pop(buf)

      {:reply, val, new_buf}
    end

    ## handle_cast

    def handle_cast({:insert, val}, buf) do
      new_buf = Cbuf.insert(buf, val)

      {:noreply, new_buf}
    end
  end
  ```
  """

  @behaviour Cbuf

  @opaque t :: %__MODULE__{
    impl: map,
    size: non_neg_integer,
    start: non_neg_integer,
    current: non_neg_integer,
    empty: boolean
  }

  defstruct impl: %{}, size: 0, start: 0, current: 0, empty: true

  @doc """
  Create a new circular buffer of a given size.

      iex> Cbuf.Map.new(5)
      #Cbuf<[]>
  """
  @spec new(pos_integer) :: t
  def new(size) when size > 0 do
    %__MODULE__{
      impl: Enum.reduce(0..(size - 1), %{}, fn i, impl -> Map.put(impl, i, :undefined) end),
      size: size,
      start: 0,
      current: 0,
      empty: true
    }
  end

  @doc """
  Calculate the allocated size for the buffer.
  This is maximum addressable size of the buffer, not how many values it currently contains. For the number of values in the current buffer, see `count/1`

      iex> Cbuf.Map.new(5) |> Cbuf.Map.size()
      5
  """
  @spec size(t) :: non_neg_integer
  def size(buf) do
    buf.size
  end

  @doc """
  Whether or not the buffer is empty.
  This value corresponds to when the buffer has a `count` of zero, not its `size`.

      iex> buf = Cbuf.Map.new(5)
      iex> Cbuf.Map.empty?(buf)
      true

      iex> buf = Cbuf.Map.new(5) |> Cbuf.Map.insert("hi")
      iex> Cbuf.Map.empty?(buf)
      false

      iex> buf = Cbuf.Map.new(5) |> Cbuf.Map.insert("hi") |> Cbuf.Map.delete()
      iex> Cbuf.Map.empty?(buf)
      true
  """
  @spec empty?(t) :: boolean
  def empty?(buf) do
    buf.empty
  end

  @doc """
  Insert a value into a circular buffer.
  Values are inserted such that when the buffer is full, the oldest items are overwritten first.

      iex> buf = Cbuf.Map.new(5)
      iex> buf |> Cbuf.Map.insert("a") |> Cbuf.Map.insert("b")
      #Cbuf<["a", "b"]>

      iex> buf = Cbuf.Map.new(3)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.Map.insert(acc, val) end)
      #Cbuf<[18, 19, 20]>

      iex> buf = Cbuf.Map.new(1)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.Map.insert(acc, val) end)
      #Cbuf<[20]>
  """
  @spec insert(t, term) :: t
  def insert(buf, val) do
    current =
      if buf.empty do
        0
      else
        Kernel.rem(buf.current + 1, buf.size)
      end

    start =
      if buf.start >= current && !buf.empty do
        Kernel.rem(buf.start + 1, buf.size)
      else
        0
      end

    %{
      buf
      | impl: Map.put(buf.impl, current, val),
        start: start,
        current: current,
        empty: false
    }
  end

  @doc """
  See the oldest value in the buffer. Works in constant time.

      iex> buf = Enum.reduce(1..20, Cbuf.Map.new(3), fn(val, acc) -> Cbuf.Map.insert(acc, val) end)
      iex> Cbuf.Map.peek(buf)
      18

      iex> buf = Cbuf.Map.new(20) |> Cbuf.Map.insert("ok") |> Cbuf.Map.insert("fine")
      iex> Cbuf.Map.peek(buf)
      "ok"

      iex> Cbuf.Map.new(3) |> Cbuf.Map.peek()
      nil
  """
  @spec peek(t) :: term | nil
  def peek(buf) do
    index = buf.start
    %{^index => value} = buf.impl

    case value do
      :undefined -> nil
      val -> val
    end
  end

  @doc """
  Return the oldest value in the buffer, and a new buffer with that value removed.

      iex> buf = Enum.reduce(1..20, Cbuf.Map.new(3), fn(val, acc) -> Cbuf.Map.insert(acc, val) end)
      iex> {val, buf} = Cbuf.Map.pop(buf)
      iex> {val, Cbuf.Map.to_list(buf)} # Elixir has trouble inspecting a nested struct, see https://hexdocs.pm/ex_unit/ExUnit.DocTest.html#module-opaque-types
      {18, [19, 20]}

      iex> {val, buf} = Cbuf.Map.new(1) |> Cbuf.Map.insert("hi") |> Cbuf.Map.pop()
      iex> {val, Cbuf.Map.to_list(buf)}
      {"hi", []}
  """
  @spec pop(t) :: {term | nil, t}
  def pop(buf) do
    {peek(buf), delete(buf)}
  end

  @doc """
  Return a new buffer with the oldest item in the buffer removed.

      iex> buf = Enum.reduce(1..20, Cbuf.Map.new(3), fn(val, acc) -> Cbuf.Map.insert(acc, val) end)
      iex> buf = Cbuf.Map.delete(buf)
      iex> Cbuf.Map.peek(buf)
      19

      iex> buf = Enum.reduce(1..6, Cbuf.Map.new(5), fn(val, acc) -> Cbuf.Map.insert(acc, val) end)
      iex> buf = Cbuf.Map.delete(buf)
      iex> Cbuf.Map.peek(buf)
      3

      iex> buf = Enum.reduce(1..6, Cbuf.Map.new(5), fn(val, acc) -> Cbuf.Map.insert(acc, val) end)
      iex> Cbuf.Map.delete(buf) |> Cbuf.Map.count()
      4

      iex> buf = Cbuf.Map.new(5)
      iex> buf = Cbuf.Map.insert(buf, "ok")
      iex> Cbuf.Map.delete(buf)
      #Cbuf<[]>

      iex> buf = Cbuf.Map.new(5)
      iex> Cbuf.Map.delete(buf)
      #Cbuf<[]>
  """
  @spec delete(t) :: t
  def delete(buf) do
    start_equals_current = buf.start == buf.current

    start =
      if !start_equals_current && !buf.empty do
        Kernel.rem(buf.start + 1, buf.size)
      else
        0
      end

    empty = start_equals_current

    current =
      if empty do
        0
      else
        buf.current
      end

    %{
      buf
      | impl: Map.put(buf.impl, buf.start, :undefined),
        start: start,
        current: current,
        empty: empty
    }
  end

  @doc """
  Convert a circular buffer to a list. The list is ordered by age, oldest to newest.
  This operation takes linear time.

      iex> buf = Cbuf.Map.new(5)
      iex> buf |> Cbuf.Map.insert("a") |> Cbuf.Map.insert("b") |> Cbuf.Map.to_list()
      ["a", "b"]

      iex> buf = Cbuf.Map.new(3)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.Map.insert(acc, val) end) |> Cbuf.Map.to_list()
      [18, 19, 20]

      iex> Cbuf.Map.new(5) |> Cbuf.Map.to_list()
      []
  """
  @spec to_list(t) :: [term] | []
  def to_list(buf) do
    do_to_list(buf, [], count(buf)) |> Enum.reverse()
  end

  defp do_to_list(_buf, list, 0), do: list

  defp do_to_list(buf, list, remaining) do
    index = buf.start
    %{^index => value} = buf.impl

    buf = %{buf | start: Kernel.rem(buf.start + 1, buf.size)}

    do_to_list(buf, [value | list], remaining - 1)
  end

  @doc """
  Returns the count of the non-empty values in the buffer.

      iex> Cbuf.Map.new(5) |> Cbuf.Map.insert("hi") |> Cbuf.Map.count()
      1

      iex> Cbuf.Map.new(5) |> Cbuf.Map.count()
      0

      iex> Cbuf.Map.new(5) |> Cbuf.Map.insert(nil) |> Cbuf.Map.count()
      1

      iex> Cbuf.Map.new(5) |> Cbuf.Map.insert("hi") |> Cbuf.Map.delete() |> Cbuf.Map.count()
      0

      iex> buf = Enum.reduce(1..13, Cbuf.Map.new(5), &Cbuf.Map.insert(&2, &1))
      iex> Cbuf.Map.delete(buf) |> Cbuf.Map.count()
      4

      iex> Cbuf.Map.new(3) |> Cbuf.Map.delete() |> Cbuf.Map.delete() |> Cbuf.Map.count()
      0
  """
  @spec count(t) :: non_neg_integer
  def count(buf) do
    case {buf.start, buf.current, buf.empty} do
      {s, c, false} when c > s ->
        c + 1 - s

      {s, c, false} when s > c ->
        buf.size - (s - c - 1)

      {s, c, false} when s == c ->
        1

      {_, _, true} ->
        0
    end
  end

  @doc """
  Queries `buf` for the presence of `val`.

      iex> Cbuf.Map.new(5) |> Cbuf.Map.insert("hello") |> Cbuf.Map.member?("hello")
      true

      iex> Cbuf.Map.new(5) |> Cbuf.Map.insert("hello") |> Cbuf.Map.member?("nope")
      false
  """
  @spec member?(t, term) :: boolean
  def member?(buf, val) do
    buf.impl
    |> Map.values()
    |> Stream.filter(fn v -> v != :undefined end)
    |> Stream.filter(fn v -> v == val end)
    |> Enum.empty?()
    |> Kernel.not()
  end

  defimpl Collectable, for: Cbuf.Map do
    def into(original) do
      collector_fun = fn
        buf, {:cont, val} ->
          Cbuf.Map.insert(buf, val)

        buf, :done ->
          buf

        _buf, :halt ->
          :ok
      end

      {original, collector_fun}
    end
  end

  defimpl Enumerable, for: Cbuf.Map do
    def count(buf), do: {:ok, Cbuf.Map.count(buf)}
    def member?(buf, val), do: {:ok, Cbuf.Map.member?(buf, val)}
    def reduce(buf, acc, fun), do: Enumerable.List.reduce(Cbuf.Map.to_list(buf), acc, fun)
    def slice(_buf), do: {:error, __MODULE__}
  end

  defimpl Inspect, for: Cbuf.Map do
    import Inspect.Algebra

    def inspect(buf, opts) do
      concat(["#Cbuf<", to_doc(Cbuf.Map.to_list(buf), opts), ">"])
    end
  end
end
