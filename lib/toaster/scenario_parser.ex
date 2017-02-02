defmodule Toaster.ScenarioParser do

  @spec parse_scenarios(String.t) :: []
  def parse_scenarios(dir) do
    dir
    |> Toaster.process_feature_files(&extract_scenario_map/1)
    |> List.flatten()
  end

  defp extract_scenario_map(filepath) do
    filepath
    |> File.stream!([:read, :utf8])
    |> Enum.reduce(%{map_list: [], line: 1}, &match_scenario_title/2)
    |> Map.get(:map_list)
  end

  defp match_scenario_title(line, acc) do
    ~r/Scenario: (?<scenario>.*$)/
    |> Regex.named_captures(line)
    |> capture_scenario_title(acc)
  end

  defp capture_scenario_title(nil, %{:map_list => map_list, :line => line}),
    do: %{map_list: map_list, line: line + 1}
  defp capture_scenario_title(captures, %{:map_list => map_list, :line => line}) do
    map = %{title: captures["scenario"], line: line}
    %{map_list: [map|map_list], line: line + 1}
  end
end
