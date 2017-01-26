defmodule Toaster do
  @moduledoc """
  """

  @doc """
  """
  @spec enumerate_feature_files(String.t) :: [String.t]
  def enumerate_feature_files(path) do
    feature_files = :filelib.fold_files(path, ".*\.feature$", false,
      fn(filename, acc) -> [filename|acc] end, [])

    output_feature_files(path, feature_files)

    for file <- feature_files, do: IO.inspect(parse_feature_file(file))
  end

  defp output_feature_files(path, []), do: "No feature files in #{path}"
  defp output_feature_files(path, file_list) do
    "Files in #{path}:" <>
    Enum.reduce(file_list, "", fn (filename, acc) -> acc <> ~s/#{filename}\n/ end)
  end

  def parse_feature_file(filepath) do
    IO.puts("Parsing #{filepath}")

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
