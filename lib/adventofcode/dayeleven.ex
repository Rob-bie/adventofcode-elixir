defmodule AdventOfCode.DayEleven do
  use GenServer

  # --- Day 11: Corporate Policy ---

  def start_link(initial_password) do
    GenServer.start_link(__MODULE__, initial_password)
  end

  def next_valid_password(pid) do
    next_password = next(pid)
    case next_password |> valid_password do
      true  -> next_password
      false -> next_valid_password(pid)
    end
  end

  def valid_password(password) do
    has_non_overlapping_pairs?(password) and
    no_bad_letters?(password) and
    incr_seq?(password)
  end

  def no_bad_letters?(password) do
    !(password
    |> Enum.any?(fn(c) -> c in 'iol' end))
  end

  def has_non_overlapping_pairs?(password) do
    Agent.start_link(fn -> {%{}, 0} end, name: :overlap_cache)
    result = password
    |> Stream.chunk(2, 1)
    |> Stream.with_index
    |> Stream.filter(&(match?({[c, c], _}, &1)))
    |> Enum.any?(fn({pair, index}) ->
         {cache, count} = Agent.get(:overlap_cache, fn(cc) -> cc end)
           case Dict.has_key?(cache, pair) do
             true ->
               cached_index = Dict.get(cache, pair)
               cond do
                 abs(index - cached_index) > 1 ->
                   cond do
                     count == 1 -> true
                     true ->
                       Agent.update(:overlap_cache, fn({c, count}) -> {c, count + 1} end)
                       false
                   end
                 true -> false
               end
             false ->
               cond do
                 count == 1 -> true
                 true ->
                   Agent.update(:overlap_cache, fn({cache, c}) ->
                     {Dict.put(cache, pair, index), c + 1}
                   end)
                   false
               end
         end
    end)
    Agent.stop(:overlap_cache)
    result
  end

  def incr_seq?(password) do
    password
    |> Stream.chunk(3, 1)
    |> Enum.any?(fn([a, b, c]) -> a + 1 == b and b + 1 == c end)
  end

  def next(pid) do
    GenServer.call(pid, :next)
  end

  def handle_call(:next, _sender, password) do
    next_password = password |> Enum.reverse |> next_iteration
    {:reply, next_password, next_password}
  end

  defp next_iteration([?z|rest]) do
    [?a|iterate_rest(rest, [])] |> Enum.reverse
  end

  defp next_iteration([c|rest]) do
    [c + 1|rest] |> Enum.reverse
  end

  defp iterate_rest([], acc), do: acc

  defp iterate_rest([h|rest], acc) do
    case h do
      ?z -> iterate_rest(rest, [?a|acc])
      c  -> acc ++ [c + 1|rest]
    end
  end

end
