defmodule LineOperation do
  def nothing(input) when is_bitstring(input), do: input

  def stringToNumbers(input) when is_bitstring(input) do
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
end

defmodule Day1 do
  def solve() do
    solve(File.read!("input.txt"))
    |> then(&("Result with no replace: " <> to_string(&1)))
    |> IO.puts()

    solve(File.read!("input2.txt"), &LineOperation.stringToNumbers/1)
    |> then(&("Result with replace: " <> to_string(&1)))
    |> IO.puts()
  end

  def solve(input, apply \\ &LineOperation.nothing/1)
      when is_bitstring(input) and is_function(apply) do
    String.split(input, "\n")
    |> sumLines(apply)
  end

  defp sumLines([], apply) when is_function(apply), do: 0

  defp sumLines([head | tail], apply) when is_function(apply) do
    sum =
      apply.(head)
      |> findNumbers()
      |> sumFirstAndLast()

    sum + sumLines(tail, apply)
  end

  defp findNumbers(input) when is_bitstring(input) do
    Regex.scan(~r/\d/, input)
    |> List.flatten()
    |> parseNumbers()
  end

  defp parseNumbers([]), do: []
  defp parseNumbers([head | tail]), do: [String.to_integer(head) | parseNumbers(tail)]

  defp sumFirstAndLast([]), do: 0
  defp sumFirstAndLast([head | []]), do: head * 10 + head
  defp sumFirstAndLast([head | tail]), do: head * 10 + List.last(tail)
end

# Day1.solve()
