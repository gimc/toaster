defmodule Toaster do
  @moduledoc """
  """

  @doc """
  """
  @spec get_scenario_titles(String.t) :: [String.t]
  def get_scenario_titles(dir) do
    feature_files = :filelib.fold_files(dir, ".*\.feature$", false,
      fn(filename, acc) -> [filename|acc] end, [])

    scenarios = for file <- feature_files, do: parse_feature_file(file)
    List.flatten(scenarios)
  end

  # defp output_feature_files(path, []), do: "No feature files in #{path}"
  # defp output_feature_files(path, file_list) do
  #   Enum.reduce(file_list, "", fn (filename, acc) -> acc <> ~s/#{filename}\n/ end)
  # end

  def parse_feature_file(filepath) do
    {:ok, file} = File.open(filepath, [:read])
    scenarios = Enum.reduce(File.stream!(filepath, [:read, :utf8]), [], &match_scenario_title/2)
    File.close(file)
    IO.inspect scenarios
    scenarios
  end

  defp match_scenario_title(line, acc) do
    capture_scenario_title(Regex.named_captures(~r/Scenario: (?<scenario>.*$)/, line), acc)
  end
  defp capture_scenario_title(nil, acc), do: acc
  defp capture_scenario_title(captures, acc), do: [captures["scenario"]|acc]
end
