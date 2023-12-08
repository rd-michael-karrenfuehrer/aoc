defmodule Day6 do
  def solve1(input) do
    lines =
      input
      |> String.split("\n", trim: true)
      |> Enum.map(&parseNumbers/1)

    parseRaces(Enum.at(lines, 0), Enum.at(lines, 1))
    |> Enum.reduce(1, fn race, acc ->
      numStres = getWinningStrats(race) |> Enum.count()
      acc * numStres
    end)
  end

  def solve2(input) do
    lines =
      input
      |> String.replace(" ", "")
      |> String.split("\n", trim: true)
      |> Enum.map(&parseNumbers/1)

    parseRaces(Enum.at(lines, 0), Enum.at(lines, 1))
    |> Enum.reduce(1, fn race, acc ->
      numStres = getWinningStrats(race) |> Enum.count()
      acc * numStres
    end)
  end

  defp getWinningStrats(race, wait \\ 0)
  defp getWinningStrats(race, wait) when wait == race.time, do: []

  defp getWinningStrats(race, wait) do
    traveled = (race.time - wait) * wait

    if traveled <= race.distance do
      getWinningStrats(race, wait + 1)
    else
      [wait | getWinningStrats(race, wait + 1)]
    end
  end

  defp parseRaces([], _), do: []

  defp parseRaces([time | tailTime], [distance | tailDistance]) do
    [%{time: time, distance: distance} | parseRaces(tailTime, tailDistance)]
  end

  defp parseNumbers(numbers) do
    Regex.scan(~r/\d+/, numbers)
    |> List.flatten()
    |> Enum.map(&String.to_integer/1)
  end
end

# File.read!("day6_input.txt")
# |> Day6.solve2()
# |> IO.inspect()
