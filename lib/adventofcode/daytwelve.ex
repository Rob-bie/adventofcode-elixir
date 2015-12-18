defmodule AdventOfCode.DayTwelve do

  # --- Day 12: JSAbacusFramework.io ---

  @input "./lib/adventofcode/resource/day12.txt"

  defp parse do
    @input |> File.read! |> Poison.decode!
  end

  def sum_json do
    parse |> sum_json
  end

  def sum_json(e) when is_integer(e) do
    e
  end

  def sum_json(e) when is_map(e) do
    case "red" in Dict.values(e) do
      true  -> 0
      false -> Enum.reduce(e, 0, fn({_k, v}, a) -> a + sum_json(v) end)
    end
  end

  def sum_json(e) when is_list(e) do
    Enum.reduce(e, 0, fn(e, a) -> a + sum_json(e) end)
  end

  def sum_json(_other) do
    0
  end
  
 end
