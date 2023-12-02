defmodule Cubes do
  defstruct red: 0, green: 0, blue: 0
end

defmodule Game do
  defstruct id: 0, cubes: %Cubes{}
end

defmodule Day2 do
  def solve() do
    File.read!("day2_input.txt")
    |> solve(12, 13, 14)
    |> IO.inspect()
  end

  def solve(input, red, green, blue) do
    cubes = %Cubes{red: red, green: green, blue: blue}

    lines =
      input
      |> String.split("\n")
      |> parseLines()

    %{
      part1: sumPossibleGameIds(lines, cubes),
      part2: powerMaxCubes(lines, cubes)
    }
  end

  defp parseLines([""]), do: []
  defp parseLines([]), do: []

  defp parseLines([head | tail]) do
    gameId =
      Regex.run(~r/(?<=Game\s)\d+/, head)
      |> hd()
      |> String.to_integer()

    redCubes = findNumbers(~r/\d+(?=\sred)/, head)
    greenCubes = findNumbers(~r/\d+(?=\sgreen)/, head)
    blueCubes = findNumbers(~r/\d+(?=\sblue)/, head)

    game = %Game{
      id: gameId,
      cubes: %{
        red: %{max: Enum.max(redCubes), sum: Enum.sum(redCubes)},
        green: %{max: Enum.max(greenCubes), sum: Enum.sum(greenCubes)},
        blue: %{max: Enum.max(blueCubes), sum: Enum.sum(blueCubes)}
      }
    }

    [game | parseLines(tail)]
  end

  defp findNumbers(regex, input) when is_bitstring(input) do
    Regex.scan(regex, input)
    |> List.flatten()
    |> Enum.map(&String.to_integer(&1))
  end

  defp sumPossibleGameIds([], cubes) when is_struct(cubes, Cubes), do: 0

  defp sumPossibleGameIds([head | tail], cubes) when is_struct(cubes, Cubes) do
    case isValidGame(head, cubes) do
      true -> head.id
      false -> 0
    end + sumPossibleGameIds(tail, cubes)
  end

  defp isValidGame(game, cubes) when is_struct(game, Game) and is_struct(cubes, Cubes) do
    cond do
      game.cubes.red.max > cubes.red -> false
      game.cubes.green.max > cubes.green -> false
      game.cubes.blue.max > cubes.blue -> false
      true -> true
    end
  end

  defp powerMaxCubes([], _), do: 0

  defp powerMaxCubes([head | tail], cubes) when is_struct(cubes, Cubes) do
    head.cubes.red.max * head.cubes.green.max * head.cubes.blue.max + powerMaxCubes(tail, cubes)
  end
end

Day2.solve()
