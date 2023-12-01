defmodule Day1 do
  def solve() do
    solve(File.read!("input.txt"))
    |> then(&("Result with no replace: " <> to_string(&1)))
    |> IO.puts()

    solve(File.read!("input2.txt"), &replace/1)
    |> then(&("Result with replace: " <> to_string(&1)))
    |> IO.puts()
  end

  def solve(input), do: solve(input, &noreplace/1)

  def solve(input, apply) do
    String.split(input, "\n")
    |> Enum.map(fn line -> apply.(line) end)
    |> Enum.map(fn line -> findNumbers(line) end)
    |> Enum.map(fn line -> sumFirstAndLast(line) end)
    |> Enum.sum()
  end

  def noreplace(input), do: input

  def replace(input) do
    String.replace(input, "one", "one1one")
    |> String.replace("two", "two2two")
    |> String.replace("three", "three3three")
    |> String.replace("four", "four4four")
    |> String.replace("five", "five5five")
    |> String.replace("six", "six6six")
    |> String.replace("seven", "seven7seven")
    |> String.replace("eight", "eight8eight")
    |> String.replace("nine", "nine9nine")
  end

  def findNumbers(input) do
    Regex.scan(~r/\d/, input)
    |> Enum.map(fn match -> String.to_integer(hd(match)) end)
  end

  def sumFirstAndLast([]), do: 0
  def sumFirstAndLast([head | []]), do: head * 10 + head
  def sumFirstAndLast([head | tail]), do: head * 10 + List.last(tail)
end

Day1.solve()
