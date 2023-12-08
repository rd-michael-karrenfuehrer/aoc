defmodule Day3 do
  def solve(input) do
    input
    |> String.split("\n", trim: true)
    |> splitInChars()
    |> parse()
    |> List.flatten()
    |> Enum.filter(&(&1 != 0))
    |> Enum.sort()
    |> Enum.sum()
  end

  defp splitInChars([]), do: []
  defp splitInChars([head | tail]), do: [String.split(head, "", trim: true) | splitInChars(tail)]

  def parse(_, rowNumber \\ 0)

  def parse(input, rowNumber) do
    numbers = collectValidNumbers(input, Enum.at(input, rowNumber), rowNumber)

    cond do
      length(input) < rowNumber ->
        numbers

      true ->
        [numbers | parse(input, rowNumber + 1)]
    end
  end

  def collectValidNumbers(
        input,
        row,
        rowNumber,
        position \\ 0,
        current \\ 0,
        alreadyValidated \\ false
      )

  def collectValidNumbers(_, nil, _, _, _, _), do: []
  def collectValidNumbers(_, [], _, _, _, _), do: []

  def collectValidNumbers(input, [head | tail], rowNumber, position, current, alreadyValidated) do
    case Integer.parse(head) do
      {number, _} ->
        adj = hasAdjacentSymbol(input, rowNumber, position)

        alreadyValidated = alreadyValidated || adj.valid

        cond do
          tail == [] and alreadyValidated ->
            [current * 10 + number]

          true ->
            collectValidNumbers(
              input,
              tail,
              rowNumber,
              position + 1,
              current * 10 + number,
              alreadyValidated
            )
        end

      _ ->
        case alreadyValidated do
          false ->
            collectValidNumbers(input, tail, rowNumber, position + 1, 0, false)

          _ ->
            [current | collectValidNumbers(input, tail, rowNumber, position + 1, 0, false)]
        end
    end
  end

  def hasAdjacentSymbol(input, rowNumber, position) do
    adjacentFields =
      [
        getField(input, rowNumber - 1, position - 1),
        getField(input, rowNumber - 1, position),
        getField(input, rowNumber - 1, position + 1),
        getField(input, rowNumber, position - 1),
        getField(input, rowNumber, position + 1),
        getField(input, rowNumber + 1, position - 1),
        getField(input, rowNumber + 1, position),
        getField(input, rowNumber + 1, position + 1)
      ]

    result =
      adjacentFields
      |> filterNotNil()
      |> mapIsSymbol()

    %{
      adjacentFields: adjacentFields,
      valid: orConat(result)
    }
  end

  def getField([], _, _), do: nil
  def getField(_, rowNumber, _) when rowNumber < 0, do: nil
  def getField(_, _, position) when position < 0, do: nil

  def getField(input, rowNumber, position) do
    Enum.at(input, rowNumber)
    |> getPosition(position)
  end

  def mapIsSymbol([]), do: []
  def mapIsSymbol([head | tail]), do: [isSymbol(head) | mapIsSymbol(tail)]
  def getPosition(nil, _), do: nil
  def getPosition(row, pos), do: Enum.at(row, pos)

  def filterNotNil([]), do: []
  def filterNotNil([nil | tail]), do: filterNotNil(tail)
  def filterNotNil([head | tail]), do: [head | filterNotNil(tail)]

  def orConat([]), do: false
  def orConat([head | tail]), do: head || orConat(tail)

  def isSymbol(input), do: Regex.match?(~r/[^\d.]/, input)
end

# File.read!("day3_input.txt")
# |> Day3.solve()
# |> IO.inspect(limit: :infinity)
