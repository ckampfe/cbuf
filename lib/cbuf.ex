defmodule Cbuf do
  defstruct impl: :array.new(), size: 0, start: 0, current: 0

  @doc """
  Create a new circular buffer of a given size.

      iex> Cbuf.new(5)
      #Cbuf<[]>
  """
  def new(size) when size > 0 do
    %__MODULE__{
      impl: :array.new(size: size, default: nil),
      size: size,
      start: 0,
      current: 0
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
  """
  def insert(buf, val) do
    next_start =
      if buf.start == buf.size - 1 do
        0
      else
        buf.start + 1
      end

    next_current =
      if buf.current == buf.size - 1 do
        0
      else
        buf.current + 1
      end

    %{
      buf
      | impl: :array.set(buf.current, val, buf.impl),
        start: next_start,
        current: next_current
    }
  end

  @doc """
  See the oldest value in the buffer. Works in constant time.

      iex> buf = Enum.reduce(1..20, Cbuf.new(3), fn(val, acc) -> Cbuf.insert(acc, val) end)
      iex> Cbuf.peek(buf)
      18

     iex> Cbuf.new(3) |> Cbuf.peek()
     nil
  """
  def peek(buf) do
    :array.get(buf.start, buf.impl)
  end

  @doc """
  Convert a circular buffer to a list. The list is ordered by age, oldest to newest.
  This operation takes linear time.

      iex> buf = Cbuf.new(5)
      iex> buf |> Cbuf.insert("a") |> Cbuf.insert("b") |> Cbuf.to_list()
      ["a", "b"]

      iex> Cbuf.new(5) |> Cbuf.to_list()
      []
  """
  def to_list(buf) do
    do_to_list(buf, [], count(buf))
  end

  defp do_to_list(_buf, list, 0), do: list

  defp do_to_list(buf, list, remaining) do
    if buf.start == 0 do
      do_to_list(
        %{buf | start: buf.size - 1},
        [:array.get(buf.size - 1, buf.impl) | list],
        remaining - 1
      )
    else
      do_to_list(
        %{buf | start: buf.start - 1},
        [:array.get(buf.start - 1, buf.impl) | list],
        remaining - 1
      )
    end
  end

  @doc """
  Returns the count of the non-empty values in the buffer.

      iex> Cbuf.new(5) |> Cbuf.insert("hi") |> Cbuf.count()
      1

      iex> [1,2,3,4,5,6] |> Enum.reduce(Cbuf.new(5), fn(el, acc) -> Cbuf.insert(acc, el) end)
      #Cbuf<[2, 3, 4, 5, 6]>

      iex> Cbuf.new(5) |> Cbuf.count()
      0

      iex> Cbuf.new(5) |> Cbuf.insert(nil) |> Cbuf.count()
      0
  """
  def count(buf) do
    :array.sparse_foldl(fn _idx, _val, total -> total + 1 end, 0, buf.impl)
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
        buf, {:cont, val} -> Cbuf.insert(buf, val)
        buf, :done -> buf
        _buf, :halt -> :ok
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
