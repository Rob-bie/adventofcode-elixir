defmodule AdventOfCode.DayOne do

  # --- Day 1: Not Quite Lisp ---

  @input "./lib/adventofcode/resource/day1.txt"

  defp parse do
    @input
    |> File.read!
    |> String.strip
    |> to_char_list
  end

  def what_floor?(seq) do
    Enum.reduce(seq, 0, fn(step, acc) ->
      case step do
        ?( -> acc + 1
        ?) -> acc - 1
      end
    end)
  end

  def to_the_basement!(seq) do
    Enum.reduce(seq, {0, 0}, fn(step, acc) ->
      case acc do
        {n, -1}  -> n
        {n, pos} ->
          case step do
            ?( -> {n + 1, pos + 1}
            ?) -> {n + 1, pos - 1}
          end
        n -> n
      end
    end)
  end

end
