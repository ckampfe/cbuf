defmodule CbufETSPropertiesTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  property "data in equals data out for ets" do
    check all input_list <- list_of(term()),
              size <- positive_integer(),
              max_runs: 1000,
              max_run_time: 10_000 do
      last_n = input_list |> Enum.reverse() |> Enum.take(size) |> Enum.reverse()
      buf = Enum.into(input_list, Cbuf.ETS.new(size))

      assert Cbuf.ETS.peek(buf) == List.first(last_n)
      assert Cbuf.ETS.size(buf) == size
      assert Cbuf.ETS.count(buf) <= size
      assert Cbuf.ETS.to_list(buf) == last_n

      if Enum.count(last_n) > 0 do
        assert Cbuf.ETS.member?(buf, Enum.random(last_n))
      end

      refute Cbuf.ETS.member?(buf, :undefined)

      if Cbuf.ETS.count(buf) > 0 do
        assert Cbuf.ETS.delete(buf) |> Cbuf.ETS.count() ==
                 Cbuf.ETS.count(buf) - 1
      else
        assert Cbuf.ETS.delete(buf) |> Cbuf.ETS.count() == 0
      end

      if Cbuf.ETS.count(buf) == 0 do
        assert Cbuf.ETS.empty?(buf)
      else
        refute Cbuf.ETS.empty?(buf)
      end

      if Enum.count(last_n) == 0 do
        assert Cbuf.ETS.empty?(buf)
      else
        refute Cbuf.ETS.empty?(buf)
      end

      assert Cbuf.ETS.pop(buf) == {Cbuf.ETS.peek(buf), Cbuf.ETS.delete(buf)}

      # these two should be together, because the objection is to ensure
      # that the ets table is always destroyed, so it will always error
      # on subsequent calls
      assert true == Cbuf.ETS.destroy(buf)
      assert catch_error(Cbuf.peek(buf))
    end
  end

  property "it does the Collectable stuff" do
    check all input_list <- list_of(term()),
              size <- positive_integer(),
              max_runs: 1000,
              max_run_time: 10_000 do
      last_n = input_list |> Enum.reverse() |> Enum.take(size) |> Enum.reverse()
      buf = Enum.into(input_list, Cbuf.ETS.new(size))

      assert Cbuf.ETS.to_list(buf) == last_n
    end
  end

  property "it does the Enumerable stuff" do
    check all input_list <- list_of(term()),
              size <- positive_integer(),
              range_min <- integer(0..(size - 2)),
              range_max <- integer(range_min..(size - 1)),
              max_runs: 1000,
              max_run_time: 10_000 do
      last_n = input_list |> Enum.reverse() |> Enum.take(size) |> Enum.reverse()
      buf = Enum.into(input_list, Cbuf.ETS.new(size))

      assert Enum.count(buf) == Enum.count(last_n)

      if Enum.count(last_n) > 0 do
        assert Enum.member?(buf, Enum.random(last_n))
      end

      assert Enum.reduce(buf, [], fn val, acc -> acc ++ [val] end) == last_n

      assert Enum.slice(buf, range_min..range_max) ==
               Enum.slice(last_n, range_min..range_max)
    end
  end
end
