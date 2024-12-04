defmodule Mix.Tasks.Aoc2024.Day3 do
  @moduledoc """
  Documentation for Advent of Code 2024 Day3.
  """
  use Mix.Task

  def run(_) do
    p1 = part1() |> IO.inspect(label: "Part 1")
    p2 = part2() |> IO.inspect(label: "Part 2")
    [p1, p2]
  end

  @doc """
  Solve Day3 part 1 stuff.

  ## Examples

      iex> Mix.Tasks.Aoc2024.Day3.part1("data/samples/day3p1.txt")
      161

  """
  def part1(data_file \\ "data/day3.txt") do
    regex = ~r/mul\((\d+),(\d+)\)/

    data_file
    |> Aoc.Toolbox.read_input()
    |> Enum.reduce(0, fn line, acc -> acc + extract_multiply_and_sum(line, regex) end)
  end

  @doc """
  Solve Day3 part 2 stuff.

  ## Examples

      iex> Mix.Tasks.Aoc2024.Day3.part2("data/samples/day3p2.txt")
      48

  """
  def part2(data_file \\ "data/day3.txt") do
    regex = ~r/mul\((\d+),(\d+)\)/

    data_file
    |> Aoc.Toolbox.read_input()
    |> Enum.join()
    |> String.split("do()")
    |> Enum.map(fn x -> String.split(x, "don't()") |> List.first() end)
    |> Enum.reduce(0, fn line, acc -> acc + extract_multiply_and_sum(line, regex) end)
  end

  defp extract_line_data(line, regex) do
    Regex.scan(regex, line, capture: :all_but_first)
  end

  def extract_multiply_and_sum(line, regex) do
    extract_line_data(line, regex)
    |> Enum.map(fn [a, b] -> [String.to_integer(a), String.to_integer(b)] end)
    |> Enum.reduce(0, fn [a, b], acc -> acc + (a * b) end)
  end
end
