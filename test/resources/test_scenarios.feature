Feature: Testing

  Scenario Outline: A scenario outline
    Given I do something without matching
    When I set the property "<field>" to "<value>"
    Then It should return status code 200
    And the property "<field>" is "<value>"

    Examples:
      | field                          | original_value                       | value                                |
      | isMemberSubscribedToNewsletter | true                                 | false                                |
      | isAutoRenewEnabled             | false                                | true                                 |
      | firstName                      | Simon                                | Johnny                               |
      | lastName                       | Smith                                | Thompson                             |
      | nickname                       | Boba                                 | Fett                                 |
      | nickname                       | The Dude                             |                                      |
      | emailAddress                   | steve@dave.com                       | steven@davin.com                     |
      | countryKey                     | 10                                   | 30                                   |
      | partnershipKey                 | 10                                   | 30                                   |
      | validStatus                    | 1                                    | 0                                    |
      | experimentationTrackingKey     | b50c331d-e037-4755-a03c-89d741ae481e | f6175640-9917-4b80-aca7-79d4f89d02b4 |


  Scenario: Updating member email to the email of an existing member
    Given I register a new member
    And I set the property "emailAddress" to "duplicate@email.com"
    And I register a new member
    And I set the property "emailAddress" to "unique@email.com"
    When I set the property "emailAddress" to "duplicate@email.com"
    Then the property "emailAddress" is "unique@email.com"

  Scenario Outline: Update Password to new invalid password
    Given I register a new member
    When I set the property password to "<value>"
    Then It should return status code 400

    Examples:
      | value         |
      | short         |
      | exponentially |
      | pass word     |

  Scenario: Update Password and Password Confirm doesn't match
    Given I register a new member
    When I change the password to a new non matching password using the Account Patch API
    Then It should return status code 400
