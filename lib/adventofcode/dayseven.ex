defmodule AdventOfCode.DaySeven do

  # --- Day 7: Some Assembly Required ---

  @input "./lib/adventofcode/resource/day7.txt"

  @bitwise_table %{
    "NOT"    => &:erlang.bnot/1,
    "AND"    => &:erlang.band/2,
    "OR"     => &:erlang.bor/2,
    "LSHIFT" => &:erlang.bsl/2,
    "RSHIFT" => &:erlang.bsr/2
  }

  def what_is_provided_to?(root) do
    node_or_value(root) |> eval_tree
  end

  def initialize_table do
    :ets.new(:node_table, [:named_table, :set])
    parse_circuit
  end

  def reset_circuit do
    :ets.delete(:node_table)
    initialize_table
  end

  defp parse_circuit do
    @input
    |> File.stream!
    |> Stream.map(&String.split/1)
    |> Enum.each(&parse_circuit/1)
  end

  defp parse_circuit([value, provided_to, wire]) do
    node = {wire, {provided_to, node_value(value)}}
    update_node_table(wire, node)
  end

  defp parse_circuit([not_operator, value, _provided_to, wire]) do
    node = {wire, {not_operator, node_value(value)}}
    update_node_table(wire, node)
  end

  defp parse_circuit([l_value, operator, r_value, _provided_to, wire]) do
    node = {wire, {operator, node_value(l_value), node_value(r_value)}}
    update_node_table(wire, node)
  end

  defp eval_tree(integer) when is_integer(integer) do
    integer
  end

  defp eval_tree({wire, {"->", value}}) do
    value = node_or_value(value) |> eval_tree
    update_node_table(wire, value)
    value
  end

  defp eval_tree({wire, {"NOT", value}}) do
    value = node_or_value(value) |> eval_tree
    value = @bitwise_table["NOT"].(value)
    update_node_table(wire, value)
    value
  end

  defp eval_tree({wire, {operator, l_value, r_value}}) do
    l_value = node_or_value(l_value) |> eval_tree
    r_value = node_or_value(r_value) |> eval_tree
    value = @bitwise_table[operator].(l_value, r_value)
    update_node_table(wire, value)
    value
  end

  defp node_or_value(value) when is_integer(value) do
    value
  end

  defp node_or_value(value) do
    :ets.lookup(:node_table, value) |> extract_value
  end

  defp update_node_table(wire, node) do
    :ets.insert(:node_table, {wire, node})
  end

  defp extract_value([{_key, value}]), do: value

  defp node_value(value) do
    case value =~ ~r/^\d+$/ do
      true  -> String.to_integer(value)
      false -> value
    end
  end

end
