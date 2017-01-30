defmodule ApiTests.Contexts.Property.Setter do
  use WhiteBread.Context

  alias ApiTests.State
  alias ApiTests.AccountApi
  alias ApiTests.RequestComposer
  alias ApiTests.EmailSalter

  and_ ~r/^I set the property "emailAddress" to "(?<email>[^"]+)"$/,
  fn state, %{email: email} ->
    state = State.set_if_not_exists(state, :email_salt, EmailSalter.get_salt)

    email_salt = State.retrieve(state, :email_salt)
    salted_email = EmailSalter.salt_email_address(email, email_salt)

    response = patch_property(state, "emailAddress", salted_email)

    state = State.store(state, :status_code, response.status_code)
    state = State.store(state, :response_body, response.body)

    {:ok, state}
  end

  when_ ~r/^I change the password to a new non matching password using the Account Patch API$/,
  fn state ->
    request_body = ~s([
      {"operation": "replace", "property": "password", "value": "pass123"},
      {"operation": "replace", "property": "passwordConfirm", "value": "pass1234"}
    ])

    response =
      state
      |> State.retrieve(:member_id)
      |> AccountApi.patch(request_body)

    state = State.store(state, :status_code, response.status_code)
    state = State.store(state, :body, response.body)

    {:ok, state}
  end

  when_ ~r/^I set the property password to "(?<value>[^"]+)"$/,
  fn state, %{value: value} ->
    request_body = ~s([
      {"operation": "replace", "property": "password", "value": "#{value}"},
      {"operation": "replace", "property": "passwordConfirm", "value": "#{value}"}
    ])

    response =
      state
      |> State.retrieve(:member_id)
      |> AccountApi.patch(request_body)

    state = State.store(state, :status_code, response.status_code)
    state = State.store(state, :body, response.body)

    {:ok, state}
  end

  when_ ~r/^I set multiple invalid properties$/, fn state ->
    request_body = ~s([
      {"operation": "replace", "property": "emailAddress", "value": "foo"},
      {"operation": "replace", "property": "firstName", "value": ""}
    ])

    response =
      state
      |> State.retrieve(:member_id)
      |> AccountApi.patch(request_body)

    state = State.store(state, :status_code, response.status_code)
    state = State.store(state, :body, Poison.decode!(response.body))

    {:ok, state}
  end

  and_ ~r/^I set the property "(?<property>[^"]+)" to "(?<value>true|false)"$/,
  fn state, %{property: property, value: value} ->
    boolean = String.to_atom(value)

    response = patch_property(state, property, boolean)
    state = State.store(state, :status_code, response.status_code)

    {:ok, state}
  end

  and_ ~r/^I set the property "(?<property>[^"]+)" to "(?<value>[0-9]+)"$/,
  fn state, %{property: property, value: value} ->
    value = String.to_integer(value)

    response = patch_property(state, property, value)
    state = State.store(state, :status_code, response.status_code)
    state = State.store(state, :body, response.body)

    {:ok, state}
  end

  and_ ~r/^I set the property "(?<property>[^"]+)" to ""$/,
  fn state, %{property: property} ->

    response = patch_property(state, property, "")
    state = State.store(state, :status_code, response.status_code)

    {:ok, state}
  end

  and_ ~r/^I set the property "(?<property>[^"]+)" to "(?<value>[^"]+)"$/,
  fn state, %{property: property, value: value} ->

    response = patch_property(state, property, value)
    state = State.store(state, :status_code, response.status_code)
    state = State.store(state, :body, response.body)

    {:ok, state}
  end

  and_ ~r/^I add the property "(?<property>[^"]+)" with value "(?<value>[^"]*)" to the changeset$/,
  fn state, %{property: property, value: value} ->

    state = State.add_to_changeset(state, property, value)

    {:ok, state}
  end

  defp patch_property(state, property, value) do
    request_body = RequestComposer.create_patch_body(property, value)

    state
    |> State.retrieve(:member_id)
    |> AccountApi.patch(request_body)
  end
end
