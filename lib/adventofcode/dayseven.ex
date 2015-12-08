defmodule AdventOfCode.DaySeven do

  # --- Day 7: Some Assembly Required ---

  @input "./lib/adventofcode/resource/day7.txt"

  @fun_table %{
    "NOT"    => &:erlang.bnot/1,
    "AND"    => &:erlang.band/2,
    "OR"     => &:erlang.bor/2,
    "LSHIFT" => &:erlang.bsl/2,
    "RSHIFT" => &:erlang.bsr/2
  }

  def parse do
    @input
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
  end

  defp solve do
    solve(parse, %{}, [])
  end

  defp solve([], table, []), do: table
  defp solve([], table, is), do: solve(is, table, [])

  defp solve([i=[n, _, v]|rest], table, instr) do
    case Integer.parse(n) do
      {i, _} -> solve(rest, Dict.put(table, v, i), instr)
      :error ->
        case Dict.has_key?(table, n) do
          true ->
            n = Dict.get(table, n)
            solve(rest, Dict.put(table, v, n), instr)
          false -> solve(rest, table, [i|instr])
        end
    end
  end


  defp solve([i=[op, n, _, r]|rest], table, instr) do
    case table[n] do
      nil -> solve(rest, table, [i|instr])
      n   ->
        table = Dict.put(table, r, apply(@fun_table[op], [n]))
        solve(rest, table, instr)
    end
  end

  defp solve([i=[n, op, v, _, r]|rest], table, instr) do
    [n, v] = to_value(n, v)
    case has_keys?(table, [n, v]) do
      true  ->
        operands = get_keys(table, [n, v])
        table = Dict.put(table, r, apply(@fun_table[op], operands))
        solve(rest, table, instr)
      false -> solve(rest, table, [i|instr])
    end
  end

  defp get_keys(t, keys) do
    Enum.map(keys, fn(k) -> if is_binary(k), do: Dict.get(t, k), else: k end)
  end

  defp has_keys?(t, keys) do
    Enum.all?(keys, &(Dict.has_key?(t, &1) or is_integer(&1)))
  end

  defp to_value(n, v) do
    case {Integer.parse(n), Integer.parse(v)} do
      {{x, _}, :error} -> [x, v]
      {:error, {y, _}} -> [n, y]
      {:error, :error} -> [n, v]
    end
  end

end
