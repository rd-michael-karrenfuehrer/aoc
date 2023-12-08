defmodule Day7 do
  @ratings %{
    "2" => 1,
    "3" => 2,
    "4" => 3,
    "5" => 4,
    "6" => 5,
    "7" => 6,
    "8" => 7,
    "9" => 8,
    "T" => 9,
    "J" => 10,
    "Q" => 11,
    "K" => 12,
    "A" => 13
  }

  @ratingsWithJoker %{@ratings | "J" => 0}

  def solve1(input) do
    lines =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parseHand/1)
      |> Enum.sort(&sortByCards/2)
      |> Enum.with_index()

    lines =
      lines
      |> Enum.map(fn {card, index} ->
        %{
          position: index + 1,
          points: card.bid * (index + 1)
        }
        |> Map.merge(card)
      end)

    lines =
      lines
      |> IO.inspect(limit: :infinity)

    lines
    |> Enum.reduce(0, fn card, acc -> acc + card.points end)
  end

  def solve2(input) do
    lines =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parseHand/1)
      |> Enum.sort(&sortByCardsiWithJoker/2)
      |> Enum.with_index()

    lines =
      lines
      |> Enum.map(fn {card, index} ->
        %{
          position: index + 1,
          points: card.bid * (index + 1)
        }
        |> Map.merge(card)
      end)

    lines =
      lines
      |> IO.inspect(limit: :infinity)

    lines
    |> Enum.reduce(0, fn card, acc -> acc + card.points end)
  end

  defp sortByCards(hand, otherHand) do
    cond do
      hand.raiting == otherHand.raiting -> hand.cardSum < otherHand.cardSum
      hand.raiting > otherHand.raiting -> true
      hand.raiting < otherHand.raiting -> false
    end
  end

  defp sortByCardsiWithJoker(hand, otherHand) do
    cond do
      hand.raitingWithJoker == otherHand.raitingWithJoker ->
        hand.cardSumWithJoker < otherHand.cardSumWithJoker

      hand.raitingWithJoker > otherHand.raitingWithJoker ->
        true

      hand.raitingWithJoker < otherHand.raitingWithJoker ->
        false
    end
  end

  defp parseHand(line) do
    match = Regex.named_captures(~r/(?<cards>(\w+))\s+(?<bid>(\d+))/m, line)
    cards = match["cards"] |> String.split("", trim: true)
    joker = cards |> Enum.filter(fn card -> card == "J" end) |> Enum.count()
    cardsWithoutJoker = cards |> Enum.filter(fn card -> card != "J" end)

    %{
      original: cards,
      cardsWithoutJoker: cardsWithoutJoker,
      joker: joker,
      cardSum:
        cards
        |> Enum.reduce(0, fn card, acc -> acc * 100 + Map.get(@ratings, card) end),
      cardSumWithJoker:
        cards
        |> Enum.reduce(0, fn card, acc -> acc * 100 + Map.get(@ratingsWithJoker, card) end),
      raiting:
        cards
        |> Enum.frequencies()
        |> Enum.map(fn {_, v} -> v end)
        |> Enum.sort(:desc)
        |> resolveRaiting(),
      raitingWithJoker:
        cardsWithoutJoker
        |> Enum.frequencies()
        |> Enum.map(fn {_, v} -> v end)
        |> Enum.sort(:desc)
        |> resolveRaiting(joker),
      bid: String.to_integer(match["bid"])
    }
  end

  defp resolveRaiting(frequencies, joker) do
    case frequencies do
      [] -> [5]
      _ -> [hd(frequencies) + joker | tl(frequencies)]
    end
    |> resolveRaiting()
  end

  defp resolveRaiting(frequencies) do
    case frequencies do
      [5] -> 1
      [4, 1] -> 2
      [3, 2] -> 3
      [3, 1, 1] -> 4
      [2, 2, 1] -> 5
      [2, 1, 1, 1] -> 6
      [1, 1, 1, 1, 1] -> 7
    end
  end
end

# File.read!("day7_input.txt")
# |> Day7.solve2()
# |> IO.inspect()
