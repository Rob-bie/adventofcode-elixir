defmodule AdventOfCode.DayNine do

  # --- Day 9: All in a Single Night ---

  @input "./lib/adventofcode/resource/day9.txt"

  defp parse do
    @input
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
  end

  def solve(option) do
    build_map
    |> get_paths
    |> solve(option)
  end

  defp solve(paths, option) do
    scores = Enum.map(paths, &(Enum.reduce(&1, 0, fn({_d, w}, a) -> w + a end)))
    case option do
      :shortest -> scores |> Enum.min
      :longest  -> scores |> Enum.max
    end
  end

  defp get_paths(map) do
    Enum.reduce(map, [], fn({start, dests}, a) -> [get_paths(map, [start], dests, [])|a] end)
    |> List.flatten
    |> Enum.chunk(Kernel.map_size(map) - 1)
  end

  defp get_paths(map, visited, dests, path) do
    candidates = find_candidates(visited, dests)
    case candidates do
      [] -> path 
      _  ->
        Enum.map(candidates, fn(p={dest, _w}) ->
          get_paths(map, [dest|visited], Dict.get(map, dest), [p|path])
        end)
    end
  end

  defp find_candidates(visited, dests) do
    Enum.filter(dests, fn {dest, _w} -> !(dest in visited) end)
  end

  defp build_map do
    Enum.reduce(parse, %{}, fn(l, a) -> build_map(l, a) end)
  end

  defp build_map([start, _, dest, _, weight], map) do
    weight = String.to_integer(weight)
    insert(map, {start, dest, weight}) |> insert({dest, start, weight})
  end
  
  defp insert(map, {start, dest, weight}) do
    case Dict.has_key?(map, start) do
      true  -> Dict.update!(map, start, fn(locs) -> [{dest, weight}|locs] end)
      false -> Dict.put(map, start, [{dest, weight}])
    end
  end

end
