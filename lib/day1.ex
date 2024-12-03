defmodule Mix.Tasks.Aoc2024.Day1 do
  @moduledoc """
  Documentation for Advent of Code 2024 Day1.
  """
  use Mix.Task

  def run(_) do
    p1 = part1() |> IO.inspect(label: "Part 1")
    p2 = part2() |> IO.inspect(label: "Part 2")
    [p1, p2]
  end

  @doc """
  Solve Day1 part 1 stuff.

  ## Examples

      iex> Mix.Tasks.Aoc2024.Day1.part1("data/samples/day1.txt")
      11

  """
  def part1(data_file \\ "data/day1.txt") do
    data_file
    |> Aoc.Toolbox.read_input()
    |> Enum.map(&extract_line_data/1)
    |> Aoc.Toolbox.transpose()
    |> Enum.map(&Enum.sort(&1))
    |> Aoc.Toolbox.transpose()
    |> Enum.reduce(0, fn [a, b], acc -> acc + abs(a - b) end)
  end

  @doc """
  Solve Day1 part 2 stuff.

  ## Examples

      iex> Mix.Tasks.Aoc2024.Day1.part2("data/samples/day1.txt")
      31

  """
  def part2(data_file \\ "data/day1.txt") do
    [list1, list2] = data_file
    |> Aoc.Toolbox.read_input()
    |> Enum.map(&extract_line_data(&1))
    |> Aoc.Toolbox.transpose()
    |> Enum.map(&Enum.sort(&1))

    list1
    |> Enum.reduce(0, fn item, acc -> acc + (Enum.count(list2, &(&1 == item)) * item) end)
  end

  defp extract_line_data(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end
end
