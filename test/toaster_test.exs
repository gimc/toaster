defmodule ToasterTest do
  use ExUnit.Case
  doctest Toaster

  @feature_filepath __DIR__ <> "/resources"

  test "pulls out scenario titles from feature file as a list" do

    titles = Toaster.get_scenario_titles(@feature_filepath)

    assert Enum.member?(titles, "Updating member email to the email of an existing member")
    assert Enum.member?(titles, "Update Password and Password Confirm doesn't match")
  end

  test "correctly determines line number of scenario titles" do
    scenarios = Toaster.ScenarioParser.parse_scenarios(@feature_filepath)

    assert Enum.member?(scenarios, %{title: "Updating member email to the email of an existing member", line: 24})
    assert Enum.member?(scenarios, %{title: "Update Password and Password Confirm doesn't match", line: 43})
  end

end
