defmodule AdventOfCode.DayThree do

  # --- Day 3: Perfectly Spherical Houses in a Vacuum ---

  @input "./lib/adventofcode/resource/day3.txt"

  defp parse do
    @input
    |> File.read!
    |> String.strip
    |> to_char_list
  end

  def who_got_a_present? do
    deliver_presents!(parse)
    |> HashSet.size
  end

  def more_presents! do
    input = parse
    s = Enum.take_every(input, 2)
    r = Enum.drop(input, 1) |> Enum.take_every(2)
    HashSet.union(deliver_presents!(s), deliver_presents!(r))
    |> HashSet.size
  end

  defp deliver_presents!(route) do
    Enum.reduce(route, {{0, 0}, HashSet.new}, fn(step, acc) ->
      case {step, acc} do
        {?^, {{x, y}, set}} -> {{x, y - 1}, HashSet.put(set, {x, y})}
        {?v, {{x, y}, set}} -> {{x, y + 1}, HashSet.put(set, {x, y})}
        {?<, {{x, y}, set}} -> {{x - 1, y}, HashSet.put(set, {x, y})}
        {?>, {{x, y}, set}} -> {{x + 1, y}, HashSet.put(set, {x, y})}
      end
    end)
    |> (fn {dest, set} -> HashSet.put(set, dest) end).()
  end

end
