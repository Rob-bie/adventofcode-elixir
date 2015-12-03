defmodule AdventOfCode.DayTwo do

  # --- Day 2: I Was Told There Would Be No Math ---

  @input "./lib/adventofcode/resource/day2.txt"

  defp parse do
    @input
    |> File.read!
    |> String.strip
    |> String.split(["\n", "x"], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.chunk(3)
  end

  def how_much_paper? do
    data = parse
    Enum.map(data, fn
      dims=[l, w, h] ->
        base_area = (2*l*w) + (2*w*h) + (2*h*l)
        dims
        |> Enum.sort
        |> Enum.take(2)
        |> Enum.reduce(1, &Kernel.*/2)
        |> (fn(smallest_side) -> smallest_side + base_area end).()
    end)
    |> Enum.sum
  end

  def how_much_ribbon? do
    data = parse
    Enum.map(data, fn
      dims=[l, w, h] ->
        base_area = l * w * h
        dims
        |> Enum.sort
        |> Enum.take(2)
        |> (fn [s1, s2] -> (s1*2) + (s2*2) end).()
        |> (fn(smallest_perimeter) -> smallest_perimeter + base_area end).()
    end)
    |> Enum.sum
  end

end
