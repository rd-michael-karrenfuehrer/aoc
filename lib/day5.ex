defmodule Day5 do
  def solve1(input) do
    [head | tail] =
      input
      |> String.split("\n\n", trim: true)

    seeds = parseSeeds(head)
    IO.inspect(seeds)

    tail
    |> parseMappers()
    |> mapNumbers(seeds)
    |> Enum.min()
  end

  def solve2(input) do
    [head | tail] =
      input
      |> String.split("\n\n", trim: true)

    mappers =
      tail
      |> parseMappers()

    parseSeeds(head)
    |> createSeedRanges()
    |> Task.async_stream(
      fn range ->
        IO.puts("range: #{inspect(range)}")
        rangeSize = range.last

        Task.async_stream(
          range,
          fn number ->
            mapNumber(mappers, number)
          end,
          timeout: :infinity
        )
        |> Enum.min()
      end,
      timeout: :infinity
    )
    |> Enum.min()
  end

  defp createSeedRanges([]), do: []
  defp createSeedRanges([[] | []]), do: []

  defp createSeedRanges([start | rest]) do
    [head | tail] = rest
    [start..(start + head - 1) | createSeedRanges(tail)]
  end

  defp parseSeeds(input) do
    match =
      Regex.named_captures(
        ~r/^seeds:\h*(?<numbers>(\d+\h*)+)/,
        input
      )

    parseNumbers(match["numbers"])
  end

  defp parseMappers([]), do: []
  defp parseMappers([head | tail]), do: [parseMapper(head) | parseMappers(tail)]

  defp parseMapper(input) do
    String.split(input, "\n", trim: true)
    |> parseMapperLine()
  end

  defp parseMapperLine([]), do: []

  defp parseMapperLine([head | tail]) do
    match =
      Regex.named_captures(
        ~r/(?<dest>(\d+))\s+(?<src>(\d+))\s+(?<length>(\d+))/m,
        head
      )

    case match do
      nil ->
        parseMapperLine(tail)

      _ ->
        length = String.to_integer(match["length"])
        src = String.to_integer(match["src"])
        dest = String.to_integer(match["dest"])

        [
          %{
            range: src..(src + length - 1),
            src: src,
            dest: dest,
            length: length
          }
          | parseMapperLine(tail)
        ]
    end
  end

  defp parseNumbers(numbers) do
    numbers
    |> String.split(" ", trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp mapNumbers(_, []), do: []

  defp mapNumbers(mappers, [head | tail]),
    do: [mapNumber(mappers, head) | mapNumbers(mappers, tail)]

  defp mapNumber([], number), do: number

  defp mapNumber([head | tail], number) do
    mapped = applyMapper(head, number)
    mapNumber(tail, mapped)
  end

  def applyMapper([], number), do: number

  def applyMapper([head | tail], number) do
    mapped = applyRange(head, number)

    if mapped != number do
      mapped
    else
      applyMapper(tail, mapped)
    end
  end

  defp applyRange(mapper, number) do
    if number in mapper.range do
      number + mapper.dest - mapper.src
    else
      number
    end
  end
end

input = """
seeds: 79 14 55 13

seed-to-soil map:
50 98 2
52 50 48

soil-to-fertilizer map:
0 15 37
37 52 2
39 0 15

fertilizer-to-water map:
49 53 8
0 11 42
42 0 7
57 7 4

water-to-light map:
88 18 7
18 25 70

light-to-temperature map:
45 77 23
81 45 19
68 64 13

temperature-to-humidity map:
0 69 1
1 0 69

humidity-to-location map:
60 56 37
56 93 4
"""

# Day5.solve2(input)
# |> IO.inspect()

# File.read!("day5_input.txt")
# |> Day5.solve2()
# |> IO.inspect()
