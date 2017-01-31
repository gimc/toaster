defmodule Toaster.ScenarioParser do

  @spec parse_scenarios(String.t) :: []
  def parse_scenarios(dir) do
    List.flatten(Toaster.process_feature_files(dir, &extract_scenario_map/1))
  end

  defp extract_scenario_map(filepath) do
    {:ok, file} = File.open(filepath, [:read])
    acc = Enum.reduce(File.stream!(filepath, [:read, :utf8]), %{map_list: [], line: 1}, &match_scenario_title/2)
    File.close(file)
    acc[:map_list]
  end

  defp match_scenario_title(line, acc) do
    capture_scenario_title(Regex.named_captures(~r/Scenario: (?<scenario>.*$)/, line), acc)
  end
  defp capture_scenario_title(nil, acc), do: %{map_list: acc[:map_list], line: acc[:line] + 1}
  defp capture_scenario_title(captures, acc) do
    map = %{title: captures["scenario"], line: acc[:line]}
    %{map_list: [map|acc[:map_list]], line: acc[:line] + 1}
  end
end
