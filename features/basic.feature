Feature: GOV.UK Template (Header & Footer)
	#@javascript

	Scenario: See the Header & Footer
		Given I am on the home page
		Then I should see "Crown copyright"
    And I should see "GDS Goals"

  Scenario: See basic nav
    Given I am signed in
    Then I should see "Vision"
    And I should see "Groups and Teams"

  Scenario: Login
    Given I am logged in
    Then I should see "Testy McTesterton"

  Scenario: Upload Goals
    When I import new goals
    Then I should see "Import successful"
    And I should see "Build a time machine"
		And I should see "Operations"
		#headcount for operations
		And I should see "83"
		#budget for Digital
		And I should see "99.6m"

  Scenario: Import goals and look around
		When I import new goals
		And I click "Expand all"
		Then I should see "bendy straws"
    When I click "Groups and Teams"
    Then I should see "Team A"
    And I should see "Team B"
    When I click on "Team C"
    Then I should see "2"
    And I should see "Smallish connected thing"
		When I click "Vision"
		And I click "Operations"
		Then I should see "Team D"
		And I should see "3"
		And I should see "Build a time machine"
