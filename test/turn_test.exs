defmodule TurnTest do
  use ExUnit.Case
  alias Monsweeper.Turn

  test "oob left" do
    assert Turn.check_oob(1, :left)
  end

  test "oob up" do
    assert Turn.check_oob(1, :up)
  end

  test "oob down" do
    assert Turn.check_oob(9, :down)
  end

  test "oob right" do
    assert Turn.check_oob(3, :right)
  end

  test "turn down" do
    t = %Turn{}
    tx = Turn.down(t)
    assert tx.space == 4
  end

  test "turn up" do
    t = %Turn{space: 9}
    tx = Turn.up(t)
    assert tx.space == 6
  end

  test "turn left" do
    t = %Turn{space: 2}
    tx = Turn.left(t)
    assert tx.space == 1
  end

  test "turn right" do
    t = %Turn{space: 2}
    tx = Turn.right(t)
    assert tx.space == 3
  end
end
