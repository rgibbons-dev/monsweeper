defmodule GrassTest do
  use ExUnit.Case
  alias Monsweeper.Grass

  test "generating the grid squares" do
    assert length(Grass.gen()) == 9
  end

  test "swapping a tuple's second element" do
    {num, o} = Grass.tuple_swap({1, :x})
    assert num == 1 and o == :o
  end

  test "replacing some x's with o's" do
    f_len = Grass.setup()
      |> Map.values()
      |> Enum.filter(fn elem -> elem == :o end)
      |> length()
    assert f_len == 2
  end
end
