defmodule Toaster.ContextDetail do

  defstruct [:regex, :line, :word]

  @word_map %{
    "given_" => "Given",
    "when_" => "When",
    "then_" => "Then",
    "and_" => "And"
  }

  def create_feature_regex(context) do
    {:ok, regex} = Regex.compile("^\s+#{@word_map[context.word]} +#{context.regex}$")
    regex
  end
end
