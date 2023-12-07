defmodule Day7Test do
  use ExUnit.Case

  test "day 7 solve1" do
    input = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

    assert Day7.solve1(input) == 6440
  end
  
  test "day 7 solver2" do
    input = """
    32T3K 765
    T55J5 684
    KK677 28
    KTJJT 220
    QQQJA 483
    """

    assert Day7.solve2(input) == 5905
  end
end
end
