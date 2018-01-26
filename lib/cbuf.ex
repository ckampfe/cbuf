defmodule Cbuf do
  defstruct impl: :array.new(), size: 0, start: 0, current: 0

  def new() do
    new(0)
  end

  def new(size) do
    impl =
      if size > 0 do
        :array.new(size: size)
      else
        :array.new()
      end

    %__MODULE__{
      impl: impl,
      size: size,
      start: 0,
      current: 0
    }
  end

  def size(buf) do
    buf.size
  end

  def insert(buf, element) do
    next_start =
      cond do
        buf.start == buf.size - 1 ->
          0

        true ->
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
      | impl: :array.set(buf.current, element, buf.impl),
        start: next_start,
        current: next_current
    }
  end

  def to_list(buf) do
    do_to_list(buf, [], Cbuf.count(buf))
  end

  def do_to_list(_buf, list, 0), do: list

  def do_to_list(buf, list, remaining) do
    cond do
      buf.start == 0 ->
        do_to_list(
          %{buf | start: buf.size - 1},
          [:array.get(buf.size - 1, buf.impl) | list],
          remaining - 1
        )

      true ->
        do_to_list(
          %{buf | start: buf.start - 1},
          [:array.get(buf.start - 1, buf.impl) | list],
          remaining - 1
        )
    end
  end

  def count(buf) do
    :array.sparse_foldl(fn _idx, _val, total -> total + 1 end, 0, buf.impl)
  end

  def member?(buf, val) do
    :array.sparse_foldl(fn _idx, v, acc -> acc || val == v end, false, buf.impl)
  end

  defimpl Enumerable do
    def count(buf), do: {:ok, Cbuf.count(buf)}
    def member?(buf, val), do: {:ok, Cbuf.member?(buf, val)}
    def reduce(buf, acc, fun), do: Enumerable.List.reduce(Cbuf.to_list(buf), acc, fun)
    def slice(_buf), do: {:error, __MODULE__}
  end
end
