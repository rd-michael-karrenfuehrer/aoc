defmodule Day4 do
  def solve1(input) do
    input
    |> String.split("\n", trim: true)
    |> parse()
    |> Enum.map(&Map.get(&1, :points))
    |> Enum.sum()
  end

  def solve2(input) do
    input
    |> String.split("\n", trim: true)
    |> parse()
    |> countCards()
  end

  defp parse([]), do: []
  defp parse([head | tail]), do: [parseLine(head) | parse(tail)]

  defp parseLine(line) do
    match =
      Regex.named_captures(
        ~r/Card\s*(?<card>\d+):\s*(?<winningNumbers>(\d+\s*)+) \|\s*(?<myNumbers>(\d+\s*)+)/,
        line
      )

    winningNumbers = parseNumbers(match["winningNumbers"])
    myNumbers = parseNumbers(match["myNumbers"])

    amountMatchingNumbers =
      MapSet.intersection(
        MapSet.new(winningNumbers),
        MapSet.new(myNumbers)
      )
      |> Enum.count()

    %{
      card: match["card"] |> String.to_integer(),
      winningNumbers: winningNumbers,
      myNumbers: myNumbers,
      amountMatchingNumbers: amountMatchingNumbers,
      points: calculatePoints(amountMatchingNumbers),
      amount: 1
    }
  end

  defp parseNumbers(numbers) do
    numbers
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp calculatePoints(0), do: 0
  defp calculatePoints(1), do: 1
  defp calculatePoints(points), do: 2 * calculatePoints(points - 1)

  defp countCards([]), do: 0

  defp countCards([head | tail]) do
    amountMatchingNumbers = head[:amountMatchingNumbers]

    head[:amount] +
      (tail
       |> addCopiesForEachCard(head[:amount], amountMatchingNumbers)
       |> countCards())
  end

  defp addCopiesForEachCard(cards, 0, _), do: cards

  defp addCopiesForEachCard(cards, times, amount) do
    addCopyInNextCards(cards, amount)
    |> addCopiesForEachCard(times - 1, amount)
  end

  defp addCopyInNextCards(cards, 0), do: cards

  defp addCopyInNextCards(cards, times) do
    card =
      Enum.at(cards, times - 1)
      |> Map.update(
        :amount,
        1,
        fn amount -> amount + 1 end
      )

    cards
    |> List.replace_at(times - 1, card)
    |> addCopyInNextCards(times - 1)
  end
end

File.read!("day4_input.txt")
|> Day4.solve2()
|> IO.inspect(limit: :infinity)
