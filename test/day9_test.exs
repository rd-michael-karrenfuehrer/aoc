defmodule Day9Test do
  use ExUnit.Case

  test "day 9 solve1" do
    input = """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

    assert Day9.solve1(input) == 114
  end

  test "day 9 solver2" do
    input = """
    0 3 6 9 12 15
    1 3 6 10 15 21
    10 13 16 21 30 45
    """

    assert Day9.solve2(input) == 2
  end
end
