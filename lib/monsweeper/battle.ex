defmodule Monsweeper.Battle do
  alias Monsweeper.Mon
  # entrypoint to battle sequence
  # assuming player's pikachu already created
  def trigger(pika) do
    e = %Mon{
      name: "Electrode",
      move1: %{tackle: 20},
      move2: %{explosion: 100},
      hp: 150
    }
    battle_seq(pika, e, :player)
  end

  # player loss guard
  def battle_seq(p_mon, _cpu_mon, _cur) when p_mon.hp <= 0 do
    IO.puts("Your Pikachu fainted...")
    :lost
  end

  # cpu loss guard
  # returns a tuple: win indicator, pikachu state
  def battle_seq(p_mon, cpu_mon, _cur) when cpu_mon.hp <= 0 do
    IO.puts("The wild Electrode fainted!")
    {:won, p_mon}
  end

  # cpu loss guard

  # recursive function handling battle sequence
  # always starts with player
  # if it's cpu's turn, next turn will be player's and so on
  def battle_seq(p_mon, cpu_mon, cur) do
    case cur do
      :player -> p_round(p_mon, cpu_mon)
      :cpu -> cpu_round(p_mon, cpu_mon)
    end
  end

  # player's round of battle
  def p_round(p_mon, cpu_mon) do
    # was it protected last round? if so, then disable buff
    if p_mon.buff do
      %{p_mon | buff: false}
    end
    # get user picked move and apply
    move = IO.gets("Pick a move! Protect=1, Thunderbolt=2 (1/2)\n")
      |> String.trim()
    case move do
      "1" ->
        IO.puts("Pikachu used Protect!")
        battle_seq(%{p_mon | buff: true}, cpu_mon, :cpu)
      "2" ->
        IO.puts("Pikachu used Thunderbolt")
        battle_seq(p_mon, Mon.hurt(cpu_mon, p_mon.move2.thunderbolt), :cpu)
      _ ->
        IO.puts("Invalid input! Go again.")
        p_round(p_mon, cpu_mon)
    end
  end

  # cpu's round of battle
  def cpu_round(p_mon, cpu_mon) do
    # sentinel for Protect
    if p_mon.buff do
      IO.puts("Pikachu blocked Electrode!")
      battle_seq(p_mon, cpu_mon, :player)
    end
    case Enum.random([1, 2]) do
      1 ->
        IO.puts("Electrode used Tackle!")
        battle_seq(Mon.hurt(p_mon, cpu_mon.move1.tackle), cpu_mon, :player)
      2 ->
        IO.puts("Electrode used Explosion!")
        battle_seq(Mon.hurt(p_mon, cpu_mon.move2.explosion), cpu_mon, :player)
    end
  end
end
