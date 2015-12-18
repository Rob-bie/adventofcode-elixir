defmodule AdventOfCode.DayFourteen do
  use GenServer

  @input "./lib/adventofcode/resource/day14.txt"

  defp parse do
    @input
    |> File.read!
    |> String.split("\n", trim: true)
    |> Enum.map(&String.split/1)
    |> Enum.map(&extract_reindeer_data/1)
  end

  def elapse(pid) do
    GenServer.cast(pid, :elapse)
  end

  def statistics(pid) do
    {elapsed, data} = GenServer.call(pid, :statistics)
    IO.puts("    AFTER #{elapsed} SECONDS ELAPSED")
    :io.format("|~-10s|~10s|~10s|~n", ["NAME", "DISTANCE", "SCORE"])
    :io.format("~34c~n", [?-])
    Enum.each(data, fn(map) ->
      :io.format("|~-10s|~10w|~10w|~n", [map.name, map.distance, map.score])
    end)
  end

  def start_link do
    GenServer.start_link(__MODULE__, {0, []})
  end

  def init({0, []}) do
    reindeer_agents = Enum.map(parse, fn(reindeer) ->
      {:ok, pid} = Agent.start_link(fn -> reindeer end)
      pid
    end)
    {:ok, {0, reindeer_agents}}
  end

  def handle_call(:statistics, _from, state={elapsed, reindeers}) do
    data = Enum.map(reindeers, fn(a) -> Agent.get(a, fn(state) -> state end) end)
    {:reply, {elapsed, data}, state}
  end

  def handle_cast(:elapse, {elapsed, reindeers}) do
    Enum.each(reindeers, fn(reindeer) ->
     Agent.get_and_update(reindeer, &({&1, update_reindeer_data(&1)}))
    end)
    inc_winning_reindeer(reindeers)
    {:noreply, {elapsed + 1, reindeers}}
  end

  defp update_reindeer_data(reindeer=%{state: :fly, fly_time: 1, immutable: {f, _}}) do
    Dict.update!(reindeer, :state, fn(:fly) -> :idle end)
    |> Dict.update!(:distance, fn(d) -> d + reindeer.speed end)
    |> Dict.update!(:fly_time, fn(_) -> f end)
  end

  defp update_reindeer_data(reindeer=%{state: :fly}) do
    Dict.update!(reindeer, :fly_time, fn(f) -> f - 1 end)
    |> Dict.update!(:distance, fn(d) -> d + reindeer.speed end)
  end

  defp update_reindeer_data(reindeer=%{state: :idle, rest_time: 1, immutable: {_, r}}) do
    Dict.update!(reindeer, :state, fn(:idle) -> :fly end)
    |> Dict.update!(:rest_time, fn(_) -> r end)
  end

  defp update_reindeer_data(reindeer=%{state: :idle}) do
    Dict.update!(reindeer, :rest_time, fn(r) -> r - 1 end)
  end

  defp inc_winning_reindeer(reindeers) do
    max_distance = Enum.map(reindeers, fn(pid) ->
      Agent.get(pid, fn(state) -> state.distance end)
    end)
    |> Enum.max

    Enum.each(reindeers, fn(pid) ->
      state = Agent.get(pid, fn(state) -> state end)
      case state.distance == max_distance do
        true  ->
          Agent.update(pid, fn(state) -> Dict.update!(state, :score, fn(s) -> s + 1 end) end)
        false ->
          :ignore
      end
    end)
  end

  defp extract_reindeer_data(reindeer) do
    [name, _, _fly, speed, _, _, fly_time,
     _, _, _, _, _rest, _, rest_time, _] = reindeer

    %{
       name:      name,
       speed:     integer(speed),
       fly_time:  integer(fly_time),
       rest_time: integer(rest_time),
       state:     :fly,
       distance:  0,
       score:     0,
       immutable: {integer(fly_time), integer(rest_time)}
     }
  end

  defp integer(bin), do: String.to_integer(bin)

end
