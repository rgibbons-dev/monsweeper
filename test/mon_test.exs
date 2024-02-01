defmodule MonTest do
  use ExUnit.Case
  alias Monsweeper.Mon

  test "correctly deduct hp" do
     m = %Mon{
      name: "TestMon",
      move1: "Tackle",
      move2: "Protect",
      hp: 100
     }
     delta_m = Mon.hurt(m, 50)
     assert delta_m.hp == 50
  end
end
