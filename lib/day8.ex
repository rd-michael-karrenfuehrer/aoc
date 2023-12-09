defmodule Day8 do
  require Math

  def solve1(input) do
    [instructions | mappers] =
      input
      |> String.split("\n", trim: true)

    instructions =
      instructions
      |> String.split("", trim: true)

    mappers = parseMappers(mappers)
    findPath(instructions, mappers, "AAA", "ZZZ")
  end

  def solve2(input) do
    [instructions | mappers] =
      input
      |> String.split("\n", trim: true)

    instructions =
      instructions
      |> String.split("", trim: true)

    mappers = parseMappers(mappers)

    startingPoints =
      mappers
      |> Map.keys()
      |> Enum.filter(fn x -> String.ends_with?(x, "A") end)

    startingPoints
    |> Enum.map(fn x -> findGhostPath(x, instructions, mappers) end)
    |> Enum.reduce(&Math.lcm/2)
    |> IO.inspect()

    # findPath(instructions, mappers, "11A")
  end

  defp findGhostPath(value, instructions, mappers) do
    cond do
      String.ends_with?(value, "Z") ->
        0

      true ->
        [instruction | tail] = instructions

        mapper = Map.get(mappers, value)

        case instruction do
          "R" -> 1 + findGhostPath(mapper.right, tail ++ [instruction], mappers)
          "L" -> 1 + findGhostPath(mapper.left, tail ++ [instruction], mappers)
        end
    end
  end

  defp findPath(_, _, value, finish) when value == finish, do: 0

  defp findPath(instructions, mappers, value, finish) do
    IO.inspect(to_string(instructions), limit: :infinity)
    [instruction | tail] = instructions

    mapper = Map.get(mappers, value)

    case instruction do
      "R" -> 1 + findPath(tail ++ [instruction], mappers, mapper.right, finish)
      "L" -> 1 + findPath(tail ++ [instruction], mappers, mapper.left, finish)
    end
  end

  defp parseMappers([]), do: %{}

  defp parseMappers([head | tail]) do
    [key | mapper] =
      head
      |> String.split("=", trim: true)

    mapper =
      hd(mapper)
      |> String.replace("(", "")
      |> String.replace(")", "")
      |> String.replace(" ", "")
      |> String.split(",", trim: true)

    [left | right] = mapper

    parsedMapper = %{String.trim(key) => %{left: left, right: hd(right)}}

    parsedMapper
    |> Map.merge(parseMappers(tail))
  end
end

#File.read!("day8_input.txt")
#|> Day8.solve2()
#|> IO.inspect()
