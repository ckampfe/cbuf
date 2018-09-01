defmodule CbufQueueTest do
  use ExUnit.Case, async: true
  doctest Cbuf.Queue

  describe "queue protocol tests" do
    test "Enumerable" do
      list = ["a", "b", "c", "d", "e", "f", "g"]
      empty = Cbuf.Queue.new(5)
      partial = Cbuf.Queue.new(5) |> Cbuf.Queue.insert("ok")

      filled =
        Enum.reduce(list, Cbuf.Queue.new(5), fn element, acc ->
          Cbuf.Queue.insert(acc, element)
        end)

      assert Enum.count(empty) == 0
      assert Enum.count(partial) == 1
      assert Enum.count(filled) == 5

      assert Enum.member?(empty, "something") == false
      assert Enum.member?(filled, "f") == true
      assert Enum.member?(filled, "a") == false

      assert Enum.reduce(empty, "", fn val, acc -> acc <> val end) == ""
      assert Enum.reduce(partial, "", fn val, acc -> acc <> val end) == "ok"
      assert Enum.reduce(filled, "", fn val, acc -> acc <> val end) == "cdefg"

      assert Enum.slice(empty, 0..2) == []
      assert Enum.slice(partial, 0..2) == ["ok"]
      assert Enum.slice(filled, 0..2) == ["c", "d", "e"]
    end

    test "Collectable" do
      buf =
        Cbuf.Queue.new(5)
        |> Cbuf.Queue.insert(1)
        |> Cbuf.Queue.insert(2)
        |> Cbuf.Queue.insert(3)

      assert Enum.into([1, 2, 3], Cbuf.Queue.new(5)) |> Cbuf.Queue.to_list() ==
               Cbuf.Queue.to_list(buf)
    end
  end
end
