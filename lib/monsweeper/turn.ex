defmodule Monsweeper.Turn do
  defstruct [ :pika, space: 1 ]

  # hardcoded (for now) size of tall grass grid
  # the same n is also used in Grass, so they should be in sync
  # n = 3
  # n^2 = 9

  # check if the move to be made will result in an out of bounds
  def check_oob(space, dir) do
    case dir do
      :left ->
        space == 1 or
        rem((space - 1), 3) == 0 or
        rem((space - 1), 6) == 0
      # annoying me so hardcoding the ranges for left and right
      :right ->
        rem((space + 1), 3) == 1 or
        rem((space + 1), 6) == 1 or
        rem((space + 1), 9) == 1
      :up -> (space - 3) < 0
      :down -> (space + 3) > 9
    end
  end

  # go left
  def left(turn) do
    if check_oob(turn.space, :left) do
      :err
    else
      %{turn | space: turn.space - 1}
    end
  end

  # go right
  def right(turn) do
    if check_oob(turn.space, :right) do
      :err
    else
      %{turn | space: turn.space + 1}
    end
  end

  # go up
  def up(turn) do
    if check_oob(turn.space, :up) do
      :err
    else
      %{turn | space: turn.space - 3}
    end
  end

  # go down
  def down(turn) do
    if check_oob(turn.space, :down) do
      :err
    else
      %{turn | space: turn.space + 3}
    end
  end
end
