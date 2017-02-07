defmodule Toaster.ContextParser do
  @moduledoc """
    Parses a context file, creating associated regexes that can be used to
    find the related clauses in feature files
  """

  alias Toaster.ContextDetail

  @regex ~r/(?<word>given_|when_|then_|and_) +?~r\/\^(?<regex>.*)\$\/ *?,/

  def parse(filepath) when is_binary(filepath) do
    filepath
    |> File.stream!([:read, :utf8])
    |> Enum.reduce(%{details: [], line: 1}, &check_line/2)
    |> Map.get(:details)
  end

  def check_line(line, %{details: details, line: line_number}) do
    new_details =
      @regex
      |> Regex.named_captures(line)
      |> collect_regex(line_number, details)

    %{details: new_details, line: line_number + 1}
  end

  defp collect_regex(%{"word" => word, "regex" => regex}, line_number, details) do
    context_detail = %ContextDetail{
      word: word,
      regex: regex,
      line: line_number
    }

    [context_detail|details]
    #["^\s+#{@word_map[word]} +#{regex}$"|details]
  end
  defp collect_regex(_captures, _line_number, details), do: details

end
