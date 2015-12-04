defmodule AdventOfCode.DayFour do

  # --- Day 4: The Ideal Stocking Stuffer ---

  def find_hash!(secret_key, leading_zeroes) do
    find_hash!(secret_key, 1, leading_zeroes)
  end

  defp find_hash!(secret_key, n, leading_zeroes) do
    merged_key = secret_key <> to_string(n)
    hash = :crypto.md5(merged_key) |> Base.encode16
    case String.starts_with?(hash, leading_zeroes) do
      true  -> n
      false -> find_hash!(secret_key, n + 1, leading_zeroes)
    end
  end

end
