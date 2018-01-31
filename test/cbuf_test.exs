defmodule CbufTest do
  use ExUnit.Case, async: true
  use ExUnitProperties
  doctest Cbuf

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
      end
    end
  end

  describe "tests" do
    test "size" do
      buf_sized = Cbuf.new(5)
      assert Cbuf.size(buf_sized) == 5
    end

    test "to_list" do
      empty = Cbuf.new(5)
      partial = Cbuf.new(5) |> Cbuf.insert("ok")
      list = ["a", "b", "c", "d", "e"]

      filled =
        Enum.reduce(list, Cbuf.new(5), fn element, acc ->
          Cbuf.insert(acc, element)
        end)

      assert Cbuf.to_list(empty) == []
      assert Cbuf.to_list(partial) == ["ok"]
      assert Cbuf.to_list(filled) == list
    end

    test "insert" do
      list = ["a", "b", "c", "d", "e", "f", "g"]

      buf =
        Enum.reduce(list, Cbuf.new(5), fn element, acc ->
          Cbuf.insert(acc, element)
        end)

      assert Cbuf.to_list(buf) == ["c", "d", "e", "f", "g"]
    end

    test "count" do
      list = ["a", "b", "c", "d", "e", "f", "g"]
      empty = Cbuf.new(5)
      sized_but_empty = Cbuf.new(5)
      sized_partial = Cbuf.new(5) |> Cbuf.insert("a") |> Cbuf.insert("b")

      sized_filled =
        Enum.reduce(list, Cbuf.new(5), fn element, acc ->
          Cbuf.insert(acc, element)
        end)

      assert Cbuf.count(empty) == 0
      assert Cbuf.count(sized_but_empty) == 0
      assert Cbuf.count(sized_partial) == 2
      assert Cbuf.count(sized_filled) == 5
    end

    test "member" do
      list = ["a", "b", "c", "d", "e", "f", "g"]
      empty = Cbuf.new(5)

      filled =
        Enum.reduce(list, Cbuf.new(5), fn element, acc ->
          Cbuf.insert(acc, element)
        end)

      assert Cbuf.member?(empty, "something") == false
      assert Cbuf.member?(filled, "f") == true
      assert Cbuf.member?(filled, "a") == false
    end

    test "Enumerable" do
      list = ["a", "b", "c", "d", "e", "f", "g"]
      empty = Cbuf.new(5)
      partial = Cbuf.new(5) |> Cbuf.insert("ok")

      filled =
        Enum.reduce(list, Cbuf.new(5), fn element, acc ->
          Cbuf.insert(acc, element)
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
        Cbuf.new(5)
        |> Cbuf.insert(1)
        |> Cbuf.insert(2)
        |> Cbuf.insert(3)

      assert Enum.into([1, 2, 3], Cbuf.new(5)) |> Cbuf.to_list() == Cbuf.to_list(buf)
    end
  end
end
