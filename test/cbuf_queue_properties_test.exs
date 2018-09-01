defmodule CbufQueuePropertiesTest do
  use ExUnit.Case, async: true
  use ExUnitProperties

  property "data in equals data out for maps" do
    check all input_list <- list_of(term()),
              size <- positive_integer(),
              max_runs: 300,
              max_run_time: 10_000 do
      last_n = input_list |> Enum.reverse() |> Enum.take(size) |> Enum.reverse()
      buf = Enum.into(input_list, Cbuf.Queue.new(size))

      assert Cbuf.Queue.peek(buf) == List.first(last_n)
      assert Cbuf.Queue.size(buf) == size
      assert Cbuf.Queue.count(buf) <= size
      assert Cbuf.Queue.to_list(buf) == last_n

      assert Cbuf.Queue.delete(buf) |> Cbuf.Queue.to_list() ==
               Enum.drop(last_n, 1)

      if Enum.count(last_n) > 0 do
        assert Cbuf.Queue.member?(buf, Enum.random(last_n))
      end

      refute Cbuf.Queue.member?(buf, :undefined)

      if Cbuf.Queue.count(buf) > 0 do
        assert Cbuf.Queue.delete(buf) |> Cbuf.Queue.count() ==
                 Cbuf.Queue.count(buf) - 1
      else
        assert Cbuf.Queue.delete(buf) |> Cbuf.Queue.count() == 0
      end

      if Cbuf.Queue.count(buf) == 0 do
        assert Cbuf.Queue.empty?(buf)
      else
        refute Cbuf.Queue.empty?(buf)
      end

      if Enum.count(last_n) == 0 do
        assert Cbuf.Queue.empty?(buf)
      else
        refute Cbuf.Queue.empty?(buf)
      end

      assert Cbuf.Queue.pop(buf) ==
               {Cbuf.Queue.peek(buf), Cbuf.Queue.delete(buf)}
    end
  end

  property "it does the Collectable stuff" do
    check all input_list <- list_of(term()),
              size <- positive_integer(),
              max_runs: 300,
              max_run_time: 10_000 do
      last_n = input_list |> Enum.reverse() |> Enum.take(size) |> Enum.reverse()
      buf = Enum.into(input_list, Cbuf.Queue.new(size))

      assert Cbuf.Queue.to_list(buf) == last_n
    end
  end

  property "it does the Enumerable stuff" do
    check all input_list <- list_of(term()),
              size <- positive_integer(),
              range_min <- integer(0..(size - 2)),
              range_max <- integer(range_min..(size - 1)),
              max_runs: 300,
              max_run_time: 10_000 do
      last_n = input_list |> Enum.reverse() |> Enum.take(size) |> Enum.reverse()
      buf = Enum.into(input_list, Cbuf.Queue.new(size))

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
