defmodule AdventOfCode.DayEight do
  
  # --- Day 8: Matchsticks ---

  @input "./lib/adventofcode/resource/day8.txt"

  def parse do
    @input
    |> File.read!
    |> String.split("\n", trim: true)
  end

  def process_bin do
    parse
    |> Enum.reduce(0, fn(line, a) ->
         a + (String.length(line) - process_bin(line, -2))
       end)
  end

  def expand_bin do
    parse
    |> Enum.reduce(0, fn(line, a) ->
         a + (expand_bin(line, 2) - String.length(line))
       end)
  end

  defp process_bin(<<"">>, mem), do: mem

  defp process_bin(<<"\\x", a, b, rest::binary>>, mem) do
    case valid_hex?(a, b) do
      true  -> process_bin(rest, mem + 1)
      false -> process_bin(<<a, b, rest::binary>>, mem + 1)
    end
  end
  
  defp process_bin(<<"\\", "\"", rest::binary>>, mem), do: process_bin(rest, mem + 1)
  defp process_bin(<<"\\\\", rest::binary>>, mem),     do: process_bin(rest, mem + 1)
  defp process_bin(<<_other, rest::binary>>, mem),     do: process_bin(rest, mem + 1)

  defp expand_bin(<<"">>, inc),                   do: inc
  defp expand_bin(<<"\"", rest::binary>>, inc),   do: expand_bin(rest, inc + 2)
  defp expand_bin(<<"\\", rest::binary>>, inc),   do: expand_bin(rest, inc + 2)
  defp expand_bin(<<_other, rest::binary>>, inc), do: expand_bin(rest, inc + 1)


  defp valid_hex?(a, b) do
    Enum.all?([a, b], fn(c) -> c in '0123456789abcdef' end)
  end

end
