defmodule Toaster do
  @moduledoc """
  """

  @doc """
  """
  @spec get_scenario_titles(String.t) :: [String.t]
  def get_scenario_titles(dir) do
    scenarios = process_feature_files(dir, &parse_feature_file/1)
    List.flatten(scenarios)
  end

  def process_feature_files(dir, fun) do
    feature_files = :filelib.fold_files(dir, ".*\.feature$", false,
      fn(filename, acc) -> [filename|acc] end, [])

    for file <- feature_files, do: fun.(file)
  end

  def parse_feature_file(filepath) do
    {:ok, file} = File.open(filepath, [:read])
    scenarios = Enum.reduce(File.stream!(filepath, [:read, :utf8]), [], &match_scenario_title/2)
    File.close(file)
    scenarios
  end

  defp match_scenario_title(line, acc) do
    capture_scenario_title(Regex.named_captures(~r/Scenario: (?<scenario>.*$)/, line), acc)
  end
  defp capture_scenario_title(nil, acc), do: acc
  defp capture_scenario_title(captures, acc), do: [captures["scenario"]|acc]
end
