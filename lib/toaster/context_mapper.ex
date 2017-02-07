defmodule Toaster.ContextMapper do
  alias Toaster.ContextParser
  alias Toaster.ContextDetail

  def create_mappings(context_filepath, feature_filepath) do
    context_filepath
    |> ContextParser.parse()
    |> process_all_contexts(feature_filepath, [])
  end

  defp process_all_contexts([], _filepath, mappings), do: mappings
  defp process_all_contexts([context|rest], filepath, mappings) do
    map = %{
      context: context,
      feature_files: [
        %{ filepath => find_matching_line_numbers(filepath, ContextDetail.create_feature_regex(context)) }
      ]
    }
    process_all_contexts(rest, filepath, [map|mappings])
  end

  def find_matching_line_numbers(filepath, regex) do
    filepath
    |> File.stream!([:read, :utf8])
    |> Enum.reduce(%{:line_number => 1, :lines => []}, &(match_line(&1, &2, regex)))
    |> Map.get(:lines)
    |> Enum.reverse()
  end

  defp match_line(line, %{:line_number => line_number, :lines => lines}, regex) do
    cond do
      Regex.match?(regex, line) -> %{:line_number => line_number + 1, :lines => [line_number|lines]}
      true -> %{:line_number => line_number + 1, :lines => lines}
    end
  end

end
