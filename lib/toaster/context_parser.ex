defmodule Toaster.ContextParser do

  @regex ~r/(given_|when_|then_|and_) +?(?<regex>~r\/.*\/) *?,/

  def parse(filepath) when is_binary(filepath) do
    Enum.reduce(File.stream!(filepath, [:read, :utf8]), [], &check_line/2)
  end

  def check_line(line, regex_list) do
    collect_regex(Regex.named_captures(@regex, line), regex_list)
  end

  defp collect_regex(%{"regex" => regex}, regex_list), do: [regex|regex_list]
  defp collect_regex(_, regex_list), do: regex_list

end
