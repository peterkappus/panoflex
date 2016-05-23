Feature: Allow and manage different types of users: admins, goal owners, and non-owners. Show user info.

Scenario: Sign in as an admin and see "Manage Users", then sign out
  Given I sign in as an admin named "Jim" with the email "jim@wherever.com"
  Then I should see "Successfully signed in"
  And I should see "Manage users"

  When I click "Sign out"
  Then I should see "Successfully signed out"

Scenario: Sign in as a non-admin and DO NOT see "Manage Users"
  When I sign in as a non-admin named "Joe" with the email "joe@wherever.com"
  Then I should NOT see "Manage users"

Scenario: Get redirected when trying to access admin only functionality.
  And I sign in as a non-admin named "Joe" with the email "joe@wherever.com"
  And I visit "/users"
  Then I should see "requires admin"

@javascript
Scenario: Make someone an admin
  Given I sign in as an admin named "Jim" with the email "jim@wherever.com"
  And I create a new non-admin named "Dave" with the email "dave@test.com"
  And I click on "Manage users"
  Then I should see "Dave"
  And I should see "dave@test.com"
  When I click on the checkbox next to "dave@test.com"
  Then I should see "was successfully updated."
  When I click "Sign out"
  Then I should see "Successfully signed out"
  And I sign in using the email "dave@test.com"
  Then I should see "Manage users"

Scenario: Can't make updates as a non-owner non-admin
  Given I create a new non-admin named "Dave" with the email "dave@test.com"
  And I create a goal named "Do something" with the owner email "dave@test.com" belonging to the group called "Digital"
  When I sign in as a non-admin named "Joe" with the email "joe@wherever.com"
  And I click "Do something"
  Then I should see "Dave" within ".big_goal_meta"
  Then I should NOT see "Report progress" within "a"
  And I should NOT see "Edit" within "a"
  And I should NOT see "Remove" within "a"
  And I should NOT see "Create sub-goal" within "a"

  Given I click "Sign out"
  And I sign in as a non-admin named "Dave" with the email "dave@test.com"
  And I click "Do something"
  Then I should see "Report progress" within "a"
  And I should see "Edit" within "a"
  And I should see "Remove" within "a"
  And I should see "Create sub-goal" within "a"

@javascript
Scenario: create a sub-goal and be the owner
  Given I create a new non-admin named "Dave" with the email "dave@test.com"
  And I create a goal named "Do something" with the owner email "dave@test.com" belonging to the group called "Digital"
  When I sign in using the email "dave@test.com"
  And I click "Do something"
  And I click "Create sub-goal"
  Then I should see "Dave" within ".filter-option"
  When I fill in "goal[name]" with "A sub-goal by Dave"
  And I click "Create Goal"
  Then I should see "Dave" within ".big_goal_meta"
  And I should see "A sub-goal by Dave"

Scenario: Let me make updates against goals I own.
  Given I create a new non-admin named "Sara" with the email "sara@test.com"
  And I create a goal named "Something Sara is doing." with the owner email "sara@test.com" belonging to the group called "Digital"
  And I sign in using the email "sara@test.com"
  When I click on "Something Sara is doing."
  And I click on "Report progress"
  #Amounts are currently hidden
  #And I fill in "score[amount]" with "30"
  And I fill in "score[reason]" with "This is my reason"
  And I click "Create Score"
  Then I should see "successfully"

Scenario: Don't let me report progress against goals I don't own.
  Given I create a new non-admin named "Jane" with the email "jane@test.com"
  And I create a new non-admin named "Anna" with the email "anna@test.com"
  And I create a goal named "Something Jane is doing." with the owner email "jane@test.com" belonging to the group called "Digital"
  And I sign in using the email "anna@test.com"
  When I click on "Something Jane is doing."
  Then I should NOT see "Report progress"

@wip
Scenario: Click a user name and see goals that they own.
  #Given "Ellie" has the email "ellie@whatever.com"
  #And "ellie@whatever.com" has 20 goals.
