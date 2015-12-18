defmodule AdventOfCode.DayThirteen do

  @input "./lib/adventofcode/resource/day13.txt"

  defp parse do
    @input
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> happiness_pairs
  end

  def happiest_arrangement do
    scores = parse
    scores
    |> Dict.keys
    |> permutations
    |> Stream.map(&seating_arrangement/1)
    |> Stream.map(&score_arrangement(&1, scores))
    |> Enum.max
  end

  defp happiness_pairs(data) do
    Enum.reduce(data, %{}, fn(l, acc) ->
      case l do
        [a, _, "gain", h, _, _, _, _, _, _, b] -> insert_pair(acc, a, :gain, h, b)
        [a, _, "lose", h, _, _, _, _, _, _, b] -> insert_pair(acc, a, :lose, h, b)
      end
    end)
  end

  defp score_arrangement(arrangement, pairs) do
    Enum.reduce(arrangement, 0, fn({k, {l, r}}, a) ->
      a + pairs[k][l] + pairs[k][r]
    end)
  end

  defp seating_arrangement(perm) do
    Enum.reduce(Enum.with_index(perm), %{}, fn({name, i}, a) ->
      left = Enum.at(perm, i - 1)
      right = Enum.at(perm, rem(i + 1, length(perm)))
      Dict.put(a, name, {left, right})
    end)
  end

  defp insert_pair(map, a, type, h, b) do
    case type do
      :gain -> insert(map, a, String.to_integer(h), String.strip(b, ?.))
      :lose -> insert(map, a, -String.to_integer(h), String.strip(b, ?.))
    end
  end

  defp insert(map, a, h, b) do
    Dict.update(map, a, Dict.put(%{}, b, h), fn(m) ->
      Dict.put(m, b, h)
    end)
  end

  defp permutations([]), do: [[]]

  defp permutations(list) do
    for h <- list, t <- permutations(list -- [h]), do: [h|t]
  end

end
