defmodule Mix.Tasks.Aoc2024.Day4 do
  @moduledoc """
  Documentation for Advent of Code 2024 Day4.
  """
  use Mix.Task

  def run(_) do
    p1 = part1() |> IO.inspect(label: "Part 1")
    p2 = "" # part2() |> IO.inspect(label: "Part 2")
    [p1, p2]
  end

  @doc """
  Solve Day4 part 1 stuff.

  ## Examples

      iex> Mix.Tasks.Aoc2024.Day4.part1("data/samples/day4.txt")
      18

  """
  def part1(data_file \\ "data/day4.txt") do
    data_file
    |> Aoc.Toolbox.read_input()
    |> extract_grid_data()
    |> wordsearch_find("XMAS", :all)
  end

  @doc """
  Solve Day4 part 2 stuff.

  ## Examples

      iex> Mix.Tasks.Aoc2024.Day4.part2("data/samples/day4.txt")
      9

  """
  def part2(data_file \\ "data/day4.txt") do
    data_file
    |> Aoc.Toolbox.read_input()
    |> extract_grid_data()
    |> wordsearch_find("XMAS", :all)
  end

  defp extract_grid_data(lines) do
    lines
    |> Enum.map(&String.split(&1, "", trim: true))
  end

  # Given a grid and a word, find the number of times the word appears in the grid,
  # searching in the specified direction search pattern
  defp wordsearch_find(grid, word, search_pattern) do
    directions = wordsearch_search_directions(search_pattern)
    starting_letter = String.at(word, 0)

    grid
    |> Enum.with_index()
    |> Enum.reduce(0, fn {row, y}, row_acc ->
      value = row
      |> Enum.with_index()
      |> Enum.reduce(0, fn {col, x}, col_acc ->
        # move to the next colum if the letter at the current position does not
        # match the first letter of the word
        if col == starting_letter do
          col_acc + Enum.reduce(directions, 0, fn direction, dir_acc ->
            dir_acc + wordsearch_in_direction(grid, x, y, word, direction, 1)
          end)
        else
          col_acc
        end
      end)

      row_acc + value
    end)
  end

  # Given a grid, a column (x coordinate), a row (reflected y coordinate), a word, and a direction,
  # search for the word in the grid
  defp wordsearch_in_direction(grid, x, y, word, direction, current_index) do
    cond do
      current_index >= String.length(word) -> 1
      direction == :up ->
        if y - 1 < 0 || Enum.at(Enum.at(grid, y - 1), x) != String.at(word, current_index) do
          0
        else
          wordsearch_in_direction(grid, x, y - 1, word, :up, current_index + 1)
        end
      direction == :down ->
        if y + 1 >= Enum.count(grid) || Enum.at(Enum.at(grid, y + 1), x) != String.at(word, current_index) do
          0
        else
          wordsearch_in_direction(grid, x, y + 1, word, :down, current_index + 1)
        end
      direction == :left ->
        if x - 1 < 0 || Enum.at(Enum.at(grid, y), x - 1) != String.at(word, current_index) do
          0
        else
          wordsearch_in_direction(grid, x - 1, y, word, :left, current_index + 1)
        end
      direction == :right ->
        if x + 1 >= Enum.count(Enum.at(grid, 0)) || Enum.at(Enum.at(grid, y), x + 1) != String.at(word, current_index) do
          0
        else
          wordsearch_in_direction(grid, x + 1, y, word, :right, current_index + 1)
        end
      direction == :up_left ->
        if y - 1 < 0 || x - 1 < 0 || Enum.at(Enum.at(grid, y - 1), x - 1) != String.at(word, current_index) do
          0
        else
          wordsearch_in_direction(grid, x - 1, y - 1, word, :up_left, current_index + 1)
        end
      direction == :up_right ->
        if y - 1 < 0 || x + 1 >= Enum.count(Enum.at(grid, 0)) || Enum.at(Enum.at(grid, y - 1), x + 1) != String.at(word, current_index) do
          0
        else
          wordsearch_in_direction(grid, x + 1, y - 1, word, :up_right, current_index + 1)
        end
      direction == :down_left ->
        if y + 1 >= Enum.count(grid) || x - 1 < 0 || Enum.at(Enum.at(grid, y + 1), x - 1) != String.at(word, current_index) do
          0
        else
          wordsearch_in_direction(grid, x - 1, y + 1, word, :down_left, current_index + 1)
        end
      direction == :down_right ->
        if y + 1 >= Enum.count(grid) || x + 1 >= Enum.count(Enum.at(grid, 0)) || Enum.at(Enum.at(grid, y + 1), x + 1) != String.at(word, current_index) do
          0
        else
          wordsearch_in_direction(grid, x + 1, y + 1, word, :down_right, current_index + 1)
        end
      true -> 0
    end
  end

  defp wordsearch_search_directions(name) do
    case name do
      :all -> [:up, :down, :left, :right, :up_left, :up_right, :down_left, :down_right]
      :horizontal -> [:left, :right]
      :vertical -> [:up, :down]
      :diagonal -> [:up_left, :up_right, :down_left, :down_right]
      _ -> []
    end
  end
end
