defmodule Monsweeper.Mon do
  defstruct [ :name, :move1, :move2, hp: 0, buff: false]

  # deduct hp from the mon after a successful attack
  def hurt(mon, damage) do
    %{mon | hp: mon.hp - damage}
  end
end
