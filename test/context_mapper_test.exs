defmodule ContextMapperTest do
  use ExUnit.Case

  alias Toaster.ContextMapper
  alias Toaster.ContextDetail

  @resource_path __DIR__ <> "/resources"

  test "correctly map context function with clause in feature file" do
    context_file = @resource_path <> "/test_contexts.exs"
    feature_file = @resource_path <> "/test_scenarios.feature"
    context_mappings = ContextMapper.create_mappings(context_file, feature_file)

    expected_context = %{
      context: %ContextDetail{
        word: "and_",
        regex: ~s|I set the property "emailAddress" to "(?<email>[^"]+)"|,
        line: 6
      },
      feature_files: [
        %{@resource_path <> "/test_scenarios.feature" => [26, 28]}
      ]
    }

    assert Enum.member?(context_mappings, expected_context)
  end

end
