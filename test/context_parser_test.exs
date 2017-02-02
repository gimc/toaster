defmodule Toaster.ContextParserTest do
  use ExUnit.Case
  alias Toaster.ContextParser

  @resources_dir __DIR__ <> "/resources"

  test "parses context regexes from context files" do
    regexes = ContextParser.parse(@resources_dir <> "/test_contexts.exs")

    assert Enum.member?(regexes, "~r/^I do something without matching$/")
  end
end
