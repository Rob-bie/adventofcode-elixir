defmodule AdventOfCode.Profile.DaySevenP do
  import ExProf.Macro

  def analyze_solution do
    profile do
      AdventOfCode.DaySeven.initialize_table
      AdventOfCode.DaySeven.what_is_provided_to?("a")
    end
  end

  def profile_solution do
    analyze_solution
    :ok
  end

end
