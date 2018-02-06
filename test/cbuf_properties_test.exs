defmodule CbufPropertiesTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  describe "properties" do
    property "data in equals data out" do
      check all input_list <- list_of(term()),
                size <- positive_integer() do
        last_n = input_list |> Enum.reverse() |> Enum.take(size) |> Enum.reverse()
        buf = Enum.into(input_list, Cbuf.new(size))

        assert Cbuf.peek(buf) == List.first(last_n)
        assert Cbuf.size(buf) == size
        assert Cbuf.count(buf) <= size
        assert Cbuf.to_list(buf) == last_n
        assert Cbuf.delete(buf) |> Cbuf.to_list() == Enum.drop(last_n, 1)

        refute Cbuf.member?(buf, :undefined)

        if Cbuf.count(buf) > 0 do
          assert Cbuf.delete(buf) |> Cbuf.count() == Cbuf.count(buf) - 1
        else
          assert Cbuf.delete(buf) |> Cbuf.count() == 0
        end

        if Cbuf.count(buf) == 0 do
          assert Cbuf.empty?(buf)
        else
          refute Cbuf.empty?(buf)
        end

        if Enum.count(last_n) == 0 do
          assert Cbuf.empty?(buf)
        else
          refute Cbuf.empty?(buf)
        end

        assert Cbuf.pop(buf) == {Cbuf.peek(buf), Cbuf.delete(buf)}
      end
    end
  end
end
