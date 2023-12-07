defmodule Day6Test do
  use ExUnit.Case

  test "solve1" do
    input = """
    Time:      7  15   30
    Distance:  9  40  200
    """

    assert Day6.solve1(input) == 288
  end

  test "solve2" do
    input = """
    Time:      7  15   30
    Distance:  9  40  200
    """

    assert Day6.solve2(input) == 71503
  end
end
