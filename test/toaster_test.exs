defmodule ToasterTest do
  use ExUnit.Case
  doctest Toaster

  @feature_filepath __DIR__ <> "/resources"

  test "pulls out scenario titles from feature file" do

    titles = Toaster.get_scenario_titles(@feature_filepath)

    expected = [
      "Updating member email to the email of an existing member",
      "Update Password and Password Confirm doesn't match"
    ]

    assert titles == expected
  end

end
