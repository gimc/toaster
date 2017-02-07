defmodule Toaster.ContextParserTest do
  use ExUnit.Case

  alias Toaster.ContextDetail
  alias Toaster.ContextParser

  @resources_dir __DIR__ <> "/resources"

  test "parses context regexes from context files" do
    details = ContextParser.parse(@resources_dir <> "/test_contexts.exs")

    expected_detail = %ContextDetail{
      regex: "I do something without matching",
      word: "given_",
      line: 2
    }

    assert Enum.member?(details, expected_detail)
  end
end
