defmodule Monsweeper.Game do
  alias Monsweeper.Turn
  alias Monsweeper.Grass
  alias Monsweeper.Mon
  alias Monsweeper.Battle

  def go do
    field = Grass.setup()
    pikachu = %Mon{
      name: "Pikachu",
      move1: %{protect: 0},
      move2: %{thunderbolt: 80},
      hp: 350
    }
    IO.puts("================")
    intro = """
      Ash! It's Professor Oak. I need your help.
      In this field ahead, a gaggle of invasive
      Electrodes have taken hold. We need to
      clear them from the field so Pallet Town's
      annual Butterfree Bonanza can go on! We tried
      catching them, but they are extra-resistant;
      cause every Electrode to faint so that we can
      safely remove them from the tall grass.
      You and Pikachu are our only hope, Ash!

    """
    IO.puts(intro)
    IO.puts("================")
    instructions = """
      OK, here's how to play. You will enter the
      patch of tall grass at the top-left corner.
      The patch is five paces wide and five paces long.
      There will be eight Electrodes hidden in the grass.
      Your objective is to find all of them and defeat them
      so we can safely extract them from the grasses
      while they have fainted.

      To move, type into the console 'left', 'right',
      'up', or 'down'. When you run into an Electrode, a
      battle will begin. In this battle, you will have the choice
      between two moves: Protect, and Thunderbolt. Protect shields
      you from attack with 100% accuracy. Thunderbolt deals 80
      damage to the Electrode's hit points. There are no limits on
      the amount of times you can use a move.

      This is what the grid looks like:

      1 2 3
      4 5 6
      7 8 9

    """
    IO.puts(instructions)
    IO.puts("================")
    IO.puts("Ready? Here we go!")
    loop(field, %Turn{pika: pikachu, space: 1})
  end

  # end condition
  # can expand to handle quit, save, load
  def loop(code) do
    case code do
      -1 -> IO.puts("Game over.")
      1 -> IO.puts("You win!")
    end
  end

  def loop(f, t) do
    # check if there are any electrodes left
    # get all values, put into MapSet (to get unique elements), then get size
    # if it's one, then we win, else it's two, so we keep going
    # I could use Enum.any?/2 here, but the size is useful as a return code
    # win_cond = Map.values(f)
    #   |> MapSet.new()
    #   |> MapSet.size()
    # IO.puts(win_cond)
    # if win_cond == 1 do
    #   loop(win_cond)
    # end
    win_cond = Map.values(f) |> Enum.all?(fn e -> e == :x end)
    if win_cond do
      IO.puts("You win!")
    # the game isn't over
    else
      # we have the space and what is at the spot)
      space = t.space
      spot = Map.get(f, space)
      IO.puts("At space #{space}")
      if spot == :o do
        # if we win, update the field and pikachu's state
        # can probably do a finer-grained update
        # and just update the hp field,
        # but this expression is simpler
        # else, we lose, so end the game
        case Battle.trigger(t.pika) do
          {:won, p} ->
            {_, f_mod} = Map.get_and_update(f, space, fn o -> {o, :x} end)
            t_mod = %{t | pika: p}
            IO.puts("Pikachu has #{p.hp}HP remaining.")
            loop(f_mod, t_mod)
          :lost ->
            IO.puts("Game over.")
        end
      else
        dir = IO.gets("Which direction would you like to go? type (left/right/up/down)\n")
          |> String.trim()
        # update the Turn struct based on which direction the user selects
        case dir do
          "left" ->
            case Turn.left(t) do
              :err ->
                IO.puts("Hey! You're out of bounds!")
                loop(f,t)
              nxt -> loop(f, nxt)
            end
          "right" ->
            case Turn.right(t) do
              :err ->
                IO.puts("Hey! You're out of bounds!")
                loop(f,t)
              nxt -> loop(f, nxt)
            end
          "up" ->
            case Turn.up(t) do
              :err ->
                IO.puts("Hey! You're out of bounds!")
                loop(f,t)
              nxt -> loop(f, nxt)
            end
          "down" ->
            case Turn.down(t) do
              :err ->
                IO.puts("Hey! You're out of bounds!")
                loop(f,t)
              nxt -> loop(f, nxt)
            end
          _ ->
            IO.puts("Hey! Enter a valid direction")
            loop(f, t)
        end
      end
    end
  end
end
