defmodule Cbuf do
  defstruct impl: :array.new(), size: 0, start: 0, current: 0, empty: true

  @doc """
  Create a new circular buffer of a given size.

      iex> Cbuf.new(5)
      #Cbuf<[]>
  """
  def new(size) when size > 0 do
    %__MODULE__{
      impl: :array.new(size: size),
      size: size,
      start: 0,
      current: 0,
      empty: true
    }
  end

  @doc """
  Calculate the allocated size for the buffer.
  This is maximum addressable size of the buffer, not how many values it currently contains. For the number of values in the current buffer, see `count/1`

      iex> Cbuf.new(5) |> Cbuf.size()
      5
  """
  def size(buf) do
    buf.size
  end

  @doc """
  Insert a value into a circular buffer.
  Values are inserted such that when the buffer is full, the oldest items are overwritten first.

      iex> buf = Cbuf.new(5)
      iex> buf |> Cbuf.insert("a") |> Cbuf.insert("b")
      #Cbuf<["a", "b"]>

      iex> buf = Cbuf.new(3)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.insert(acc, val) end)
      #Cbuf<[18, 19, 20]>

      iex> buf = Cbuf.new(1)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.insert(acc, val) end)
      #Cbuf<[20]>
  """
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

    %{
      buf
      | impl: :array.set(current, val, buf.impl),
        start: start,
        current: current,
        empty: empty
    }
  end

  @doc """
  See the oldest value in the buffer. Works in constant time.

      iex> buf = Enum.reduce(1..20, Cbuf.new(3), fn(val, acc) -> Cbuf.insert(acc, val) end)
      iex> Cbuf.peek(buf)
      18

      iex> buf = Cbuf.new(20) |> Cbuf.insert("ok") |> Cbuf.insert("fine")
      iex> Cbuf.peek(buf)
      "ok"

      iex> Cbuf.new(3) |> Cbuf.peek()
      nil
  """
  def peek(buf) do
    case :array.get(buf.start, buf.impl) do
      :undefined -> nil
      val -> val
    end
  end

  @doc """
  Convert a circular buffer to a list. The list is ordered by age, oldest to newest.
  This operation takes linear time.

      iex> buf = Cbuf.new(5)
      iex> buf |> Cbuf.insert("a") |> Cbuf.insert("b") |> Cbuf.to_list()
      ["a", "b"]

      iex> buf = Cbuf.new(3)
      iex> Enum.reduce(1..20, buf, fn(val, acc) -> Cbuf.insert(acc, val) end) |> Cbuf.to_list()
      [18, 19, 20]

      iex> Cbuf.new(5) |> Cbuf.to_list()
      []
  """
  def to_list(buf) do
    do_to_list(buf, [], count(buf)) |> Enum.reverse()
  end

  defp do_to_list(_buf, list, 0), do: list

  defp do_to_list(buf, list, remaining) do
    value = :array.get(buf.start, buf.impl)

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

      iex> Cbuf.new(5) |> Cbuf.insert("hi") |> Cbuf.count()
      1

      iex> Cbuf.new(5) |> Cbuf.count()
      0

      iex> Cbuf.new(5) |> Cbuf.insert(nil) |> Cbuf.count()
      1
  """
  def count(buf) do
    case {buf.start, buf.current, buf.empty} do
      {s, c, false} when s == c + 1 ->
        buf.size

      {s, c, false} when c > s ->
        c + 1 - s

      {0, 0, true} ->
        0

      {0, 0, false} ->
        1
    end
  end

  @doc """
  Queries `buf` for the presence of `val`.

      iex> Cbuf.new(5) |> Cbuf.insert("hello") |> Cbuf.member?("hello")
      true

      iex> Cbuf.new(5) |> Cbuf.insert("hello") |> Cbuf.member?("nope")
      false
  """
  def member?(buf, val) do
    :array.sparse_foldl(fn _idx, v, acc -> acc || val == v end, false, buf.impl)
  end

  defimpl Collectable do
    def into(original) do
      collector_fun = fn
        buf, {:cont, val} ->
          Cbuf.insert(buf, val)

        buf, :done ->
          buf

        _buf, :halt ->
          :ok
      end

      {original, collector_fun}
    end
  end

  defimpl Enumerable do
    def count(buf), do: {:ok, Cbuf.count(buf)}
    def member?(buf, val), do: {:ok, Cbuf.member?(buf, val)}
    def reduce(buf, acc, fun), do: Enumerable.List.reduce(Cbuf.to_list(buf), acc, fun)
    def slice(_buf), do: {:error, __MODULE__}
  end

  defimpl Inspect do
    import Inspect.Algebra

    def inspect(buf, opts) do
      concat(["#Cbuf<", to_doc(Cbuf.to_list(buf), opts), ">"])
    end
  end
end
