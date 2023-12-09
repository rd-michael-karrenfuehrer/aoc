defmodule Day9 do
  def solve1(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> parse_numbers(line) end)
    |> Enum.map(fn numbers -> 
       create_extrapolation_list(numbers) 
      |> extrapolate()
    end)
    |> Enum.sum()
  end

  def solve2(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn line -> parse_numbers(line) end)
    |> Enum.map(fn numbers -> 
       numbers
        |> Enum.reverse()
        |> create_extrapolation_list()
        |> extrapolate()
    end)
    |> Enum.sum()
  end


  defp extrapolate(extrapolation_list, number \\ 0)
  defp extrapolate([], number), do: number
  defp extrapolate(extrapolation_list, number) do
    [head|tail] = extrapolation_list |> Enum.reverse()
    res = number + head
    extrapolate(tail, res)
  end

  defp create_extrapolation_list(input) do
    cond do
      Enum.all?(input, &(&1 == 0)) ->
        []

      true ->
        next =
          input
          |> Enum.chunk_every(2, 1)
          |> List.delete_at(-1)
          |> Enum.map(fn pair -> List.last(pair) - hd(pair) end)
        [List.last(input) | create_extrapolation_list(next)]
    end
  end

  defp parse_numbers(input) do
    input
    |> String.split(" ")
    |> Enum.map(fn number -> String.to_integer(number) end)
  end
end

#Day9.solve2(input)
#|> IO.inspect()

#File.read!("day9_input.txt")
#|> Day9.solve2()
#|> IO.inspect()
