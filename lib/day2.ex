defmodule Mix.Tasks.Aoc2024.Day2 do
  @moduledoc """
  Documentation for Advent of Code 2024 Day2.
  """
  use Mix.Task

  def run(_) do
    p1 = part1() |> IO.inspect(label: "Part 1")
    p2 = part2() |> IO.inspect(label: "Part 2")
    [p1, p2]
  end

  @doc """
  Solve Day2 part 1 stuff.

  ## Examples

      iex> Mix.Tasks.Aoc2024.Day2.part1("data/samples/day2.txt")
      2

  """
  def part1(data_file \\ "data/day2.txt") do
    data_file
    |> Aoc.Toolbox.read_input()
    |> Enum.map(&extract_line_data/1)
    |> Enum.map(&check_line/1)
    |> Enum.count(fn {check_value, _, _} -> check_value end)
  end

  @doc """
  Solve Day2 part 2 stuff.

  ## Examples

      iex> Mix.Tasks.Aoc2024.Day2.part2("data/samples/day2.txt")
      4

  """
  def part2(data_file \\ "data/day2.txt") do
    data_file
    |> Aoc.Toolbox.read_input()
    |> Enum.map(&extract_line_data/1)
    |> Enum.map(&check_line_with_dampener/1)
    |> Enum.count(fn {check_value, _, _} -> check_value end)
  end

  defp assess_op(ops, num1, num2) do
    op = cond do
      num1 > num2 -> :-
      num1 < num2 -> :+
      true -> :=
    end

    cond do
      op == := -> {false, [op | ops], num2}
      abs(num1 - num2) > 3 -> {false, [op | ops], num2}
      Enum.uniq([op | ops]) != [op] -> {false, [op | ops], num2}
      true -> {true, [op | ops], num2}
    end
  end

  defp check_line(line_data) do
    line_data
    |> Enum.reduce({true, [], nil}, fn item, {valid, ops, prev_num} ->
      case {valid, ops, prev_num} do
        {false, ops, _} -> {false, ops, item}
        {true, [], nil} -> {true, [], item}
        {true, ops, prev_num} -> assess_op(ops, prev_num, item)
      end
    end)
  end

  defp check_line_with_dampener(line_data) do
    result = check_line(line_data)

    case result do
      {true, _, _} -> result
      {false, _, _} -> try_dampener(line_data)
    end
  end

  defp extract_line_data(line) do
    line
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp try_dampener(line_data) do
    (0..(length(line_data) - 1))
    |> Enum.map(fn i -> List.delete_at(line_data, i) end)
    |> Enum.map(&check_line/1)
    |> Enum.find({false, [], nil}, &elem(&1, 0))
  end
end
