defmodule Cbuf.ETS do
  @moduledoc """
  `Cbuf.ETS` implements the `Cbuf` behaviour with an ETS table as its implementation.

  For examples of typical use, see the documentation for `new/1`, `insert/2`, `peek/1`, and `delete/1`.

  Each new buffer creates and owns a new ETS table.

  Operations that must interact with the actual data of the buffer
  (`new/1`, `insert/2`, `peek/1`, `pop/1`, `delete/1`, `to_list/1`, `member?/2`),
  perform as well as ETS does.

  Use this module if you have tried `Cbuf.Map` with a GenServer and benchmarked it against this one to determine that
  this one is faster for your application. I recommend defaulting to `Cbuf.Map`.
  This module is not currently designed or tested for parallel writes, and so I also recommend using it
  as part of a GenServer. Crucially, the `start` and `current` pointers are stored on the struct itself,
  rather than somewhere in ETS, so they are completely uncoordinated with the backing implementation and require
  updates to be serialized.
  This may change at some point if I can determine that this is a beneficial use case and can be implemented in
  a way that preserves the existing API.

  Note that this module is a superset of the `Cbuf` behaviour, implementing one additional function, `destroy/1`,
  to destroy the buffer's backing ETS table. See the function documentation for more details.
  """

  @behaviour Cbuf

  @opaque t :: %__MODULE__{
            impl: :ets.tab(),
            size: non_neg_integer,
            start: non_neg_integer,
            current: non_neg_integer,
            empty: boolean
          }

  defstruct impl: nil, size: 0, start: 0, current: 0, empty: true

  @doc """
  Create a new circular buffer of a given size.

      iex> Cbuf.ETS.new(5)
      #Cbuf<[]>
  """
  @spec new(pos_integer) :: t
  def new(size) when size > 0 do
    tid = :ets.new(:ok, [:public, :set])

    Enum.each(0..(size - 1), fn i ->
      :ets.insert(tid, {i, :undefined})
    end)

    %__MODULE__{
      impl: tid,
      size: size,
      start: 0,
      current: 0,
      empty: true
    }
  end

  @doc """
  Calculate the allocated size for the buffer.
  This is maximum addressable size of the buffer, not how many values it currently contains. For the number of values in the current buffer, see `count/1`

      iex> Cbuf.ETS.new(5) |> Cbuf.ETS.size()
      5
  """
  @spec size(t) :: non_neg_integer
  def size(buf) do
    buf.size
  end

  @doc """
  Whether or not the buffer is empty.
  This value corresponds to when the buffer has a `count` of zero, not its `size`.

      iex> buf = Cbuf.ETS.new(5)
      iex> Cbuf.ETS.empty?(buf)
      true

      iex> buf = Cbuf.ETS.new(5) |> Cbuf.ETS.insert("hi")
      iex> Cbuf.ETS.empty?(buf)
      false

      iex> buf = Cbuf.ETS.new(5) |> Cbuf.ETS.insert("hi") |> Cbuf.ETS.delete()
      iex> Cbuf.ETS.empty?(buf)
      true
  """
  @spec empty?(t) :: boolean
  def empty?(buf) do
    buf.empty
  end

  @doc """
  Insert a value into a circular buffer.
  Values are inserted such that when the buffer is full, the oldest items are overwritten first.

      iex> buf = Cbuf.ETS.new(5)
      iex> buf |> Cbuf.ETS.insert("a") |> Cbuf.ETS.insert("b")
      #Cbuf<["a", "b"]>

      iex> buf = Cbuf.ETS.new(3)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.ETS.insert(acc, val) end)
      #Cbuf<[18, 19, 20]>

      iex> buf = Cbuf.ETS.new(1)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.ETS.insert(acc, val) end)
      #Cbuf<[20]>
  """
  @spec insert(t, term) :: t
  def insert(buf, val) do
    first = 0
    size = buf.size
    last = size - 1

    {start, current, empty} =
      case {buf.start, buf.current, buf.empty} do
        # special case:
        # handle the initial case where start and current both == 0
        {s, c, true} when s == first and c == first ->
          {first, first, false}

        # special case:
        # handle the case where start and current both == 0
        # but a value has been set at current and the size
        # of the buffer == 1
        {s, c, false} when size == 1 and s == first and c == first ->
          {first, first, false}

        # special case:
        # handle the case where start and current both == 0
        # but a value has been set at current AND
        # the buffer size is larger than 1
        {s, c, false} when s == first and c == first ->
          {first, 1, false}

        # normal advance
        {s, c, false} when c > s and c != last ->
          {s, c + 1, false}

        # normal advance with wraparound
        {s, c, false} when s == first and c == last ->
          {s + 1, first, false}

        # normal advance with wraparound
        {s, c, false} when s == last and c == s - 1 ->
          {first, c + 1, false}

        # normal advance
        {s, c, false} when c == s - 1 ->
          {s + 1, c + 1, false}
      end

    :ets.insert(buf.impl, {current, val})

    %{
      buf
      | start: start,
        current: current,
        empty: empty
    }
  end

  @doc """
  See the oldest value in the buffer. Works in constant time.

      iex> buf = Enum.reduce(1..20, Cbuf.ETS.new(3), fn(val, acc) -> Cbuf.ETS.insert(acc, val) end)
      iex> Cbuf.ETS.peek(buf)
      18

      iex> buf = Cbuf.ETS.new(20) |> Cbuf.ETS.insert("ok") |> Cbuf.ETS.insert("fine")
      iex> Cbuf.ETS.peek(buf)
      "ok"

      iex> Cbuf.ETS.new(3) |> Cbuf.ETS.peek()
      nil
  """
  @spec peek(t) :: term | nil
  def peek(buf) do
    case :ets.match(buf.impl, {buf.start, :"$1"}) do
      [[:undefined]] -> nil
      [[val]] -> val
    end
  end

  @doc """
  Return the oldest value in the buffer, and a new buffer with that value removed.

      iex> buf = Enum.reduce(1..20, Cbuf.ETS.new(3), fn(val, acc) -> Cbuf.ETS.insert(acc, val) end)
      iex> {val, buf} = Cbuf.ETS.pop(buf)
      iex> {val, Cbuf.ETS.to_list(buf)} # Elixir has trouble inspecting a nested struct, see https://hexdocs.pm/ex_unit/ExUnit.DocTest.html#module-opaque-types
      {18, [19, 20]}

      iex> {val, buf} = Cbuf.ETS.new(1) |> Cbuf.ETS.insert("hi") |> Cbuf.ETS.pop()
      iex> {val, Cbuf.ETS.to_list(buf)}
      {"hi", []}
  """
  @spec pop(t) :: {term | nil, t}
  def pop(buf) do
    {peek(buf), delete(buf)}
  end

  @doc """
  Return a new buffer with the oldest item in the buffer removed.

      iex> buf = Enum.reduce(1..20, Cbuf.ETS.new(3), fn(val, acc) -> Cbuf.ETS.insert(acc, val) end)
      iex> buf = Cbuf.ETS.delete(buf)
      iex> Cbuf.ETS.peek(buf)
      19

      iex> buf = Enum.reduce(1..6, Cbuf.ETS.new(5), fn(val, acc) -> Cbuf.ETS.insert(acc, val) end)
      iex> buf = Cbuf.ETS.delete(buf)
      iex> Cbuf.ETS.peek(buf)
      3

      iex> buf = Enum.reduce(1..6, Cbuf.ETS.new(5), fn(val, acc) -> Cbuf.ETS.insert(acc, val) end)
      iex> Cbuf.ETS.delete(buf) |> Cbuf.ETS.count()
      4

      iex> buf = Cbuf.ETS.new(5)
      iex> buf = Cbuf.ETS.insert(buf, "ok")
      iex> Cbuf.ETS.delete(buf)
      #Cbuf<[]>

      iex> buf = Cbuf.ETS.new(5)
      iex> Cbuf.ETS.delete(buf)
      #Cbuf<[]>
  """
  @spec delete(t) :: t
  def delete(buf) do
    size = buf.size

    {start, current, empty} =
      case {buf.start, buf.current, buf.empty} do
        {0, 0, true} ->
          {0, 0, true}

        {s, c, false} when s < c ->
          {s + 1, c, false}

        {s, c, false} when s == c ->
          {0, 0, true}

        {s, c, false} when s > c and s == size - 1 ->
          {0, c, false}

        {s, c, false} when s > c ->
          {s + 1, c, false}
      end

    :ets.insert(buf.impl, {buf.start, :undefined})

    %{
      buf
      | start: start,
        current: current,
        empty: empty
    }
  end

  @doc """
  Convert a circular buffer to a list. The list is ordered by age, oldest to newest.
  This operation takes linear time.

      iex> buf = Cbuf.ETS.new(5)
      iex> buf |> Cbuf.ETS.insert("a") |> Cbuf.ETS.insert("b") |> Cbuf.ETS.to_list()
      ["a", "b"]

      iex> buf = Cbuf.ETS.new(3)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.ETS.insert(acc, val) end) |> Cbuf.ETS.to_list()
      [18, 19, 20]

      iex> Cbuf.ETS.new(5) |> Cbuf.ETS.to_list()
      []
  """
  @spec to_list(t) :: [term] | []
  def to_list(buf) do
    do_to_list(buf, [], count(buf)) |> Enum.reverse()
  end

  defp do_to_list(_buf, list, 0), do: list

  defp do_to_list(buf, list, remaining) do
    value =
      case :ets.match(buf.impl, {buf.start, :"$1"}) do
        [[:undefined]] -> nil
        [[val]] -> val
      end

    buf =
      if buf.start == buf.size - 1 do
        %{buf | start: 0}
      else
        %{buf | start: buf.start + 1}
      end

    do_to_list(buf, [value | list], remaining - 1)
  end

  @doc """
  Returns the count of the non-empty values in the buffer.

      iex> Cbuf.ETS.new(5) |> Cbuf.ETS.insert("hi") |> Cbuf.ETS.count()
      1

      iex> Cbuf.ETS.new(5) |> Cbuf.ETS.count()
      0

      iex> Cbuf.ETS.new(5) |> Cbuf.ETS.insert(nil) |> Cbuf.ETS.count()
      1

      iex> Cbuf.ETS.new(5) |> Cbuf.ETS.insert("hi") |> Cbuf.ETS.delete() |> Cbuf.ETS.count()
      0

      iex> buf = Enum.reduce(1..13, Cbuf.ETS.new(5), &Cbuf.ETS.insert(&2, &1))
      iex> Cbuf.ETS.delete(buf) |> Cbuf.ETS.count()
      4

      iex> Cbuf.ETS.new(3) |> Cbuf.ETS.delete() |> Cbuf.ETS.delete() |> Cbuf.ETS.count()
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

      {0, 0, false} ->
        1

      {_, _, true} ->
        0
    end
  end

  @doc """
  Queries `buf` for the presence of `val`.

      iex> Cbuf.ETS.new(5) |> Cbuf.ETS.insert("hello") |> Cbuf.ETS.member?("hello")
      true

      iex> Cbuf.ETS.new(5) |> Cbuf.ETS.insert("hello") |> Cbuf.ETS.member?("nope")
      false
  """
  @spec member?(t, term) :: boolean
  def member?(buf, val) do
    if val == :undefined do
      false
    else
      :ets.foldl(fn {_key, ets_val}, acc ->
        (ets_val == val) || acc
      end, false, buf.impl)
    end
  end

  @doc """
  Destroy the backing ETS table of a buffer. This function exists if you wish to manually dispose of the ETS table that backs the buffer. The other option is to destroy the process in which the buffer was created, as the ETS table will be disposed of when its parent process dies. See http://erlang.org/doc/man/ets.html for more information about the behavior of ETS tables.

      iex> buf = Cbuf.ETS.new(5)
      iex> buf = Cbuf.ETS.insert(buf, "ok")
      iex> Cbuf.ETS.destroy(buf)
      true

      iex> buf = Cbuf.ETS.new(5)
      iex> buf = Cbuf.ETS.insert(buf, "ok")
      iex> Cbuf.ETS.destroy(buf)
      iex> Cbuf.ETS.peek(buf)
      ** (ArgumentError) argument error
  """
  @spec destroy(t) :: true
  def destroy(buf) do
    :ets.delete(buf.impl)
  end

  defimpl Collectable, for: Cbuf.ETS do
    def into(original) do
      collector_fun = fn
        buf, {:cont, val} ->
          Cbuf.ETS.insert(buf, val)

        buf, :done ->
          buf

        _buf, :halt ->
          :ok
      end

      {original, collector_fun}
    end
  end

  defimpl Enumerable, for: Cbuf.ETS do
    def count(buf), do: {:ok, Cbuf.ETS.count(buf)}
    def member?(buf, val), do: {:ok, Cbuf.ETS.member?(buf, val)}

    def reduce(buf, acc, fun),
      do: Enumerable.List.reduce(Cbuf.ETS.to_list(buf), acc, fun)

    def slice(_buf), do: {:error, __MODULE__}
  end

  defimpl Inspect, for: Cbuf.ETS do
    import Inspect.Algebra

    def inspect(buf, opts) do
      concat(["#Cbuf<", to_doc(Cbuf.ETS.to_list(buf), opts), ">"])
    end
  end
end
