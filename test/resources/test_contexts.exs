defmodule ToasterTest.Contexts.Update do
  given_ ~r/^I do something without matching$/, fn state ->
    {:ok, state}
  end

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

  given_ ~r/^I set the property "(?<property>[^"]+)" to "(?<value>true|false)"$/,
  fn state, %{property: property, value: value} ->
    {:ok, state}
  end

  then_ ~r/^I set the property "(?<property>[^"]+)" to "(?<value>[0-9]+)"$/,
  fn state, %{property: property, value: value} ->
    {:ok, state}
  end

  when_ ~r/^I set the property "(?<property>[^"]+)" to "(?<value>[^"]+)"$/,
  fn state, %{property: property, value: value} ->
    {:ok, state}
  end

  and_ ~r/^I set the property "(?<property>[^"]+)" to "(?<value>[^"]+)"$/,
  fn state, %{property: property, value: value} ->
    {:ok, state}
  end

end
