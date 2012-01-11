Feature: Dette er en beskrivelse af hvad App'en gør.

Scenario: Login
  Given the app is running
    Then take picture

    When I touch "Name"
    And I type "Karl" into the "Name" text field
    Then I touch done

    When I toggle the switch
    And I touch the "login" button
    Then I should see "Karl"

    Then take picture

Scenario: User on map
  Given the app is running
    When I touch "Second"
    Then I should see a map
    Then I wait

    Then take picture
