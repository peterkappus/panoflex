Feature: Import goals, look around, see header/footer, etc.

	Scenario: See the Header & Footer
		Given I am on the home page
		Then I should see "Crown copyright"
    And I should see "GDS Goals"

	Scenario: Number sub-goals based on creation date (not deadline)
		Given I create a new non-admin named "Dave" with the email "dave@test.com"
		And I create a goal named "The first goal" with the owner email "dave@test.com" belonging to the group called "Digital" with a deadline of "March 2017"
		And I create a goal named "The second goal" with the owner email "dave@test.com" belonging to the group called "Digital" with a deadline of "September 2016"
		When I sign in using the email "dave@test.com"
		And I visit the home page
		Then I should see "first goal" within "#goal_1"
		And I should see "second goal" within "#goal_2"
		#now check sub-goals
		Given I create a sub-goal of "The first goal" called "subgoal 1" with a deadline of "December 2016"
		And I create a sub-goal of "The first goal" called "subgoal 2" with a deadline of "September 2016"
		#click into the goal from the homepage to see the sub-goals
		And I click on "first goal"
		Then I should see "subgoal 1" within "#goal_1"
		And I should see "subgoal 2" within "#goal_2"
		#now change the dates and see that the one created first (now with the later date) still shows up first.
		When I change the deadline of the first goal called "subgoal 1" to be "January 2017"
		#still in the same order after changing dates
		Then I should see "subgoal 1" within "#goal_1"
		And I should see "subgoal 2" within "#goal_2"

  Scenario: Upload Goals
    When I import new goals
    Then I should see "Import successful"
    And I should see "Build a time machine"
		And I should see "Operations"
		#We've hidden headcount and budget since they're likely not right anymore
		#headcount for operations
		#And I should see "83"
		#budget for Digital
		#And I should see "99.6m"

  Scenario: Import goals and look around
		When I import new goals
		#And I click on "List view"
		And I click "View all"
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

	Scenario: Import goals and create new ones
		When I import new goals
		And I click on "Operations Group"
		And I create a new goal called "Newly created test goal"
		Then I should see "Newly created test goal"
		When I create a sub-goal called "Sub goal 1"
		#we should've been redirected to the parent goal and see our sub-goal in the sub-goal list
		Then I should see "Sub goal 1"
		#one more time... (is this necessary?)
		When I create a sub-goal called "Sub goal 2"
		Then I should see "Sub goal 2"
		And I should see "Sub goal 1"

	Scenario: use previous/next links to see different goals.
		Given I import new goals
		And I sign in as a non-admin named "Peter" with the email "peter@wherever.com"
		And I click on "big goal"
		And I click on "sub-goal"
		Then I should see "Thing A"
		And I should see "Thing B"
		When I click on "Thing A"
		Then I should see "Next"
		And I should NOT see "Previous"
		When I click on "Next"
		Then I should see "Previous"
		And I should NOT see "Next"


	@javascript
	Scenario: Don't let me assign a goal to a team & group which don't match.
		Given I create a new non-admin named "Dave" with the email "dave@test.com"
		And I create a goal named "Do something" with the owner email "dave@test.com" belonging to the group called "Digital"
		And I create a team called "Team A" within the group called "Operations"
		When I sign in using the email "dave@test.com"
		And I click "Do something"
		And I click "Edit"
		Then I should see "Digital" within ".filter-option"
		When I select "Team A" from the first dropdown
		And I click "Update Goal"
		Then I should see "Team does not belong to group"
