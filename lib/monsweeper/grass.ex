defmodule Monsweeper.Grass do
  # hardcoded (for now) size of tall grass grid
  # the same n is also used in Turn, so they should be in sync
  # N = 3

  # and a hardcoded m
  # where m is the number of electrodes
  # M = 2

  # generate the grass grid
  def gen do
    # get the number of squares in the grid
    n2 = 3 * 3
    # create a list of that range, then map each element to a tuple
    # this tuple contains the space number and an atom
    # this atom represents whether there is a electrode there or not
    Enum.to_list(1..n2)
      |> Enum.map(fn elem -> {elem, :x} end)
  end

  # tuple re-assignment
  def tuple_swap(tup) do
    {space, _} = tup
    {space, :o}
  end

  # place the electrodes in the grass
  def place(grid) do
    # select m spots at random,
    # then "place" the electrodes in those spots
    osm = Enum.take_random(grid, 2)
      |> Enum.map(fn elem  -> tuple_swap(elem) end)
      |> Map.new()
    # this is courtesy of GPT, with some finishing touches from myself
    # build up a new List by prepending Tuples
    # we determine whether to add the original tuple or a modified one
    # if it exists within the map created above
    # there was an Enum.reverse/1 at the end, but I nixed that because
    # I'm exporting it as a Map
    Enum.reduce(grid, [], fn {space, gen_spot}, acc ->
       case Map.get(osm, space) do
         :o -> [{space, :o} | acc]
         _ -> [{space, gen_spot} | acc]
       end
    end)
    |> Map.new()
    # I decided to change the data structure containing the field to be a Map
    # it makes a whole lot more sense when it comes time to remove an Electrode
  end

  # compose gen and place
  def setup do
    gen() |> place()
  end
end
