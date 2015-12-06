defmodule AdventOfCode.DayFive do

  # --- Day 5: Doesn't He Have Intern-Elves For This? ---

  @input "./lib/adventofcode/resource/day5.txt"

  defp parse do
    @input
    |> File.read!
    |> String.strip
    |> String.split
  end

  # REGEX IMPLEMENTATION

  def count_nice do
    parse
    |> Enum.filter(&is_nice?/1)
    |> length
  end

  def count_extra_nice do
    parse
    |> Enum.filter(&is_extra_nice?/1)
    |> length
  end

  defp is_nice?(str) do
    has_vowels?       = str =~ ~r/(.*[aeiou]){3}/
    has_duplicate?    = str =~ ~r/(.)\1{1}/
    has_no_bad_pairs? = str =~ ~r/(ab|cd|pq|xy)/
    has_vowels? and has_duplicate? and !has_no_bad_pairs?
  end

  defp is_extra_nice?(str) do
    has_triple_pair? = str =~ ~r/(.).\1/
    has_no_overlap?  = str =~ ~r/(..).*\1/
    has_triple_pair? and has_no_overlap?
  end

  # NON-REGEX IMPLEMENTATION

  def count_nice_nr do
    parse
    |> Enum.map(&to_char_list/1)
    |> Enum.filter(&is_nice_nr?/1)
    |> length
  end

  def count_extra_nice_nr do
    parse
    |> Enum.map(&to_char_list/1)
    |> Enum.filter(&is_extra_nice_nr?/1)
    |> length
  end

  defp is_nice_nr?(cl) do
    !has_no_bad_pairs_nr?(cl) and
     has_duplicate_nr?(cl)    and
     has_vowels_nr?(cl)
  end

  defp is_extra_nice_nr?(cl) do
    has_triple_pair_nr?(cl) and
    has_no_overlap_nr?(cl)
  end

  defp has_no_bad_pairs_nr?(chars) do
    chars
    |> Stream.chunk(2, 1)
    |> Enum.any?(&(&1 in ['ab', 'cd', 'pq', 'xy']))
  end

  defp has_duplicate_nr?(chars) do
    chars
    |> Enum.dedup
    |> (fn(deduped) -> length(deduped) < length(chars) end).()
  end

  defp has_vowels_nr?(chars) do
    chars
    |> Stream.scan(0, fn(c, a) ->
        case c in 'aeiou' do
          true  -> a + 1
          false -> a
        end
      end)
    |> Enum.any?(&(&1 == 3))
  end

  def has_triple_pair_nr?(chars) do
    chars
    |> Stream.chunk(3, 1)
    |> Enum.any?(&match?([c, _center, c], &1))
  end

  def has_no_overlap_nr?(chars) do
    Agent.start_link(fn -> %{} end, name: :overlap_cache)
    result = chars
    |> Stream.chunk(2, 1)
    |> Stream.with_index
    |> Enum.any?(fn {pair, pos} ->
        cache = Agent.get(:overlap_cache, fn(cache) -> cache end)
        case Dict.has_key?(cache, pair) do
          true  ->
            cached_pos = Dict.get(cache, pair)
            cond do
              abs(pos - cached_pos) > 1 -> true
              true -> false
            end
          false ->
            Agent.update(:overlap_cache, fn(cache) ->
              Dict.put(cache, pair, pos)
            end)
            false
        end
    end)
    Agent.stop(:overlap_cache)
    result
  end

end
