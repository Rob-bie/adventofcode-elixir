defmodule AdventOfCode.DaySix do

  # --- Day 6: Probably a Fire Hazard ---

  @input "./lib/adventofcode/resource/day6.txt"

  defp parse do
    @input
    |> File.read!
    |> String.strip
    |> String.split("\n")
    |> Enum.map(&String.split/1)
    |> Enum.map(&format_input/1)
  end

  def how_many_lights_are_lit? do
    Enum.reduce(parse, init_grid(:off), fn(instruction, a) ->
      case instruction do
        {:turn_on, s, e}  -> turn_on(gen_coordinates(s, e), a)
        {:turn_off, s, e} -> turn_off(gen_coordinates(s, e), a)
        {:toggle, s, e}   -> toggle(gen_coordinates(s, e), a)
      end
    end)
    |> Enum.count(fn({_k, config}) -> config == :on end)
  end

  def total_brightness? do
    Enum.reduce(parse, init_grid(0), fn(instruction, a) ->
      case instruction do
        {:turn_on, s, e}  -> turn_on(gen_coordinates(s, e), a, :b)
        {:turn_off, s, e} -> turn_off(gen_coordinates(s, e), a, :b)
        {:toggle, s, e}   -> toggle(gen_coordinates(s, e), a, :b)
      end
    end)
    |> Enum.reduce(0, fn({_k, v}, a) -> v + a end)
  end
               
  defp turn_on(coordinates, grid) do
    Enum.reduce(coordinates, grid, fn(c, a) ->
      Dict.put(a, c, :on)
    end)
  end

  defp turn_off(coordinates, grid) do
    Enum.reduce(coordinates, grid, fn(c, a) ->
      Dict.put(a, c, :off)
    end)
  end

  defp toggle(coordinates, grid) do
    Enum.reduce(coordinates, grid, fn(c, a) ->
      config = Dict.get(a, c)
      case config do
        :on  -> Dict.put(a, c, :off)
        :off -> Dict.put(a, c, :on)
      end
    end)
  end

  defp turn_on(coordinates, grid, :b) do
    Enum.reduce(coordinates, grid, fn(c, a) ->
      Dict.update!(a, c, fn(config) -> config + 1 end)
    end)
  end

  defp turn_off(coordinates, grid, :b) do
    Enum.reduce(coordinates, grid, fn(c, a) ->
      Dict.update!(a, c, fn(config) ->
        case config do
          0 -> 0
          n -> n - 1
        end
      end)
    end)
  end

  defp toggle(coordinates, grid, :b) do
    Enum.reduce(coordinates, grid, fn(c, a) ->
      Dict.update!(a, c, fn(config) -> config + 2 end)
    end)
  end

  defp gen_coordinates({x, y}, {xx, yy}) do
    for x <- x..xx, y <- y..yy, do: {x, y}
  end

  defp init_grid(value) do
    (for x <- 0..999, y <- 0..999, do: {x, y})
    |> Enum.reduce(%{}, fn(key, a) -> Dict.put(a, key, value) end)
  end

  defp format_input([_, "on", c, _, d]),  do: to_format(:turn_on, c, d)
  defp format_input([_, "off", c, _, d]), do: to_format(:turn_off, c, d)
  defp format_input(["toggle", c, _, d]), do:to_format(:toggle, c, d)

  defp to_format(type, c, d) do
    [x, y]   = String.split(c, ",") |> Enum.map(&String.to_integer/1)
    [xx, yy] = String.split(d, ",") |> Enum.map(&String.to_integer/1)
    {type, {x, y}, {xx, yy}}
  end

end
