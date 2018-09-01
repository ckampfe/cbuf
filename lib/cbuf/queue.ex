defmodule Cbuf.Queue do
  @moduledoc """
  `Cbuf.Queue` implements the `Cbuf` behaviour with Erlang's built-in `queue` as its implementation.

  For examples of typical use, see the documentation for `new/1`, `insert/2`, `peek/1`, and `delete/1`.

  Operations that must interact with the actual data of the buffer
  (`new/1`, `insert/2`, `peek/1`, `pop/1`, `delete/1`, `to_list/1`, `member?/2`),
  perform as well as `Queue` does. This is good, as `Queue` is fast.

  Queues, like the other normal Elixir/Erlang datastructures, typically exist in process memory. For example,
  it is recommended to use this module behind a GenServer in order to share its usage across the system.
  Using `Cbuf.Queue` in this way means that updates to the buffer will be at the mercy of the process' garbage collection.
  For large data sets with a lot of process GC, [your application may benefit from a different approach](https://elixirforum.com/t/why-use-ets-when-not-to-use-it/4326/8).
  For this reason, there is also `Cbuf.ETS` that is drop-in API compatible.
  I recommend defaulting to using `Cbuf.Queue` with a GenServer and benchmarking your application.

  An example partially-complete `GenServer`  might look something like the following:

  ```
  defmodule EventTracker do
    use GenServer
    alias Cbuf.Queue, as: Cbuf

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
            impl: :queue.queue(),
            size: non_neg_integer,
            count: non_neg_integer,
            empty: boolean
          }

  defstruct impl: :queue.new(), size: 0, count: 0, empty: true

  @doc """
  Create a new circular buffer of a given size.

      iex> Cbuf.Queue.new(5)
      #Cbuf<[]>
  """
  @spec new(pos_integer) :: t
  def new(size) when size > 0 do
    %__MODULE__{
      impl: :queue.new(),
      size: size,
      count: 0,
      empty: true
    }
  end

  @doc """
  Calculate the allocated size for the buffer.
  This is maximum addressable size of the buffer, not how many values it currently contains. For the number of values in the current buffer, see `count/1`

      iex> Cbuf.Queue.new(5) |> Cbuf.Queue.size()
      5
  """
  @spec size(t) :: non_neg_integer
  def size(buf) do
    buf.size
  end

  @doc """
  Whether or not the buffer is empty.
  This value corresponds to when the buffer has a `count` of zero, not its `size`.

      iex> buf = Cbuf.Queue.new(5)
      iex> Cbuf.Queue.empty?(buf)
      true

      iex> buf = Cbuf.Queue.new(5) |> Cbuf.Queue.insert("hi")
      iex> Cbuf.Queue.empty?(buf)
      false

      iex> buf = Cbuf.Queue.new(5) |> Cbuf.Queue.insert("hi") |> Cbuf.Queue.delete()
      iex> Cbuf.Queue.empty?(buf)
      true
  """
  @spec empty?(t) :: boolean
  def empty?(buf) do
    buf.empty
  end

  @doc """
  Insert a value into a circular buffer.
  Values are inserted such that when the buffer is full, the oldest items are overwritten first.

      iex> buf = Cbuf.Queue.new(5)
      iex> buf |> Cbuf.Queue.insert("a") |> Cbuf.Queue.insert("b")
      #Cbuf<["a", "b"]>

      iex> buf = Cbuf.Queue.new(3)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.Queue.insert(acc, val) end)
      #Cbuf<[18, 19, 20]>

      iex> buf = Cbuf.Queue.new(1)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.Queue.insert(acc, val) end)
      #Cbuf<[20]>
  """
  @spec insert(t, term) :: t
  def insert(buf, val) do
    if buf.count < buf.size do
      %{
        buf
        | impl: :queue.cons(val, buf.impl),
          count: buf.count + 1,
          empty: false
      }
    else
      new_q = :queue.drop_r(buf.impl)
      %{buf | impl: :queue.cons(val, new_q), empty: false}
    end
  end

  @doc """
  See the oldest value in the buffer. Works in constant time.

      iex> buf = Enum.reduce(1..20, Cbuf.Queue.new(3), fn(val, acc) -> Cbuf.Queue.insert(acc, val) end)
      iex> Cbuf.Queue.peek(buf)
      18

      iex> buf = Cbuf.Queue.new(20) |> Cbuf.Queue.insert("ok") |> Cbuf.Queue.insert("fine")
      iex> Cbuf.Queue.peek(buf)
      "ok"

      iex> Cbuf.Queue.new(3) |> Cbuf.Queue.peek()
      nil
  """
  @spec peek(t) :: term | nil
  def peek(buf) do
    case :queue.peek_r(buf.impl) do
      {:value, value} ->
        value

      :empty ->
        nil
    end
  end

  @doc """
  Return the oldest value in the buffer, and a new buffer with that value removed.

      iex> buf = Enum.reduce(1..20, Cbuf.Queue.new(3), fn(val, acc) -> Cbuf.Queue.insert(acc, val) end)
      iex> {val, buf} = Cbuf.Queue.pop(buf)
      iex> {val, Cbuf.Queue.to_list(buf)} # Elixir has trouble inspecting a nested struct, see https://hexdocs.pm/ex_unit/ExUnit.DocTest.html#module-opaque-types
      {18, [19, 20]}

      iex> {val, buf} = Cbuf.Queue.new(1) |> Cbuf.Queue.insert("hi") |> Cbuf.Queue.pop()
      iex> {val, Cbuf.Queue.to_list(buf)}
      {"hi", []}
  """
  @spec pop(t) :: {term | nil, t}
  def pop(buf) do
    {peek(buf), delete(buf)}
  end

  @doc """
  Return a new buffer with the oldest item in the buffer removed.

      iex> buf = Enum.reduce(1..20, Cbuf.Queue.new(3), fn(val, acc) -> Cbuf.Queue.insert(acc, val) end)
      iex> buf = Cbuf.Queue.delete(buf)
      iex> Cbuf.Queue.peek(buf)
      19

      iex> buf = Enum.reduce(1..6, Cbuf.Queue.new(5), fn(val, acc) -> Cbuf.Queue.insert(acc, val) end)
      iex> buf = Cbuf.Queue.delete(buf)
      iex> Cbuf.Queue.peek(buf)
      3

      iex> buf = Enum.reduce(1..6, Cbuf.Queue.new(5), fn(val, acc) -> Cbuf.Queue.insert(acc, val) end)
      iex> Cbuf.Queue.delete(buf) |> Cbuf.Queue.count()
      4

      iex> buf = Cbuf.Queue.new(5)
      iex> buf = Cbuf.Queue.insert(buf, "ok")
      iex> Cbuf.Queue.delete(buf)
      #Cbuf<[]>

      iex> buf = Cbuf.Queue.new(5)
      iex> Cbuf.Queue.delete(buf)
      #Cbuf<[]>
  """
  @spec delete(t) :: t
  def delete(buf) do
    case buf.count do
      0 ->
        buf

      1 ->
        %{
          buf
          | impl: :queue.drop_r(buf.impl),
            count: buf.count - 1,
            empty: true
        }

      _otherwise ->
        %{buf | impl: :queue.drop_r(buf.impl), count: buf.count - 1}
    end
  end

  @doc """
  Convert a circular buffer to a list. The list is ordered by age, oldest to newest.
  This operation takes linear time.

      iex> buf = Cbuf.Queue.new(5)
      iex> buf |> Cbuf.Queue.insert("a") |> Cbuf.Queue.insert("b") |> Cbuf.Queue.to_list()
      ["a", "b"]

      iex> buf = Cbuf.Queue.new(3)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.Queue.insert(acc, val) end) |> Cbuf.Queue.to_list()
      [18, 19, 20]

      iex> Cbuf.Queue.new(5) |> Cbuf.Queue.to_list()
      []
  """
  @spec to_list(t) :: [term] | []
  def to_list(buf) do
    # do_to_list(buf, [], count(buf)) |> Enum.reverse()
    :queue.reverse(buf.impl) |> :queue.to_list()
  end

  @doc """
  Returns the count of the non-empty values in the buffer.

      iex> Cbuf.Queue.new(5) |> Cbuf.Queue.insert("hi") |> Cbuf.Queue.count()
      1

      iex> Cbuf.Queue.new(5) |> Cbuf.Queue.count()
      0

      iex> Cbuf.Queue.new(5) |> Cbuf.Queue.insert(nil) |> Cbuf.Queue.count()
      1

      iex> Cbuf.Queue.new(5) |> Cbuf.Queue.insert("hi") |> Cbuf.Queue.delete() |> Cbuf.Queue.count()
      0

      iex> buf = Enum.reduce(1..13, Cbuf.Queue.new(5), &Cbuf.Queue.insert(&2, &1))
      iex> Cbuf.Queue.delete(buf) |> Cbuf.Queue.count()
      4

      iex> Cbuf.Queue.new(3) |> Cbuf.Queue.delete() |> Cbuf.Queue.delete() |> Cbuf.Queue.count()
      0
  """
  @spec count(t) :: non_neg_integer
  def count(buf) do
    buf.count
  end

  @doc """
  Queries `buf` for the presence of `val`.

      iex> Cbuf.Queue.new(5) |> Cbuf.Queue.insert("hello") |> Cbuf.Queue.member?("hello")
      true

      iex> Cbuf.Queue.new(5) |> Cbuf.Queue.insert("hello") |> Cbuf.Queue.member?("nope")
      false
  """
  @spec member?(t, term) :: boolean
  def member?(buf, val) do
    :queue.member(val, buf.impl)
  end

  defimpl Collectable, for: Cbuf.Queue do
    def into(original) do
      collector_fun = fn
        buf, {:cont, val} ->
          Cbuf.Queue.insert(buf, val)

        buf, :done ->
          buf

        _buf, :halt ->
          :ok
      end

      {original, collector_fun}
    end
  end

  defimpl Enumerable, for: Cbuf.Queue do
    def count(buf), do: {:ok, Cbuf.Queue.count(buf)}
    def member?(buf, val), do: {:ok, Cbuf.Queue.member?(buf, val)}

    def reduce(buf, acc, fun),
      do: Enumerable.List.reduce(Cbuf.Queue.to_list(buf), acc, fun)

    def slice(_buf), do: {:error, __MODULE__}
  end

  defimpl Inspect, for: Cbuf.Queue do
    import Inspect.Algebra

    def inspect(buf, opts) do
      concat(["#Cbuf<", to_doc(Cbuf.Queue.to_list(buf), opts), ">"])
    end
  end
end
