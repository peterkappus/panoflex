Feature: Have browseable "users" in the system who own goals.

Scenario: See all the goals assigned to a user.
  Given I create a new non-admin named "Sonia Price" with the email "sonia@test.com"
  And I create a goal named "Sonia's new goal" with the owner email "sonia@test.com" belonging to the group called "Digital"
  And I create a new non-admin named "Premdass" with the email "prem@test.com"
  And I create a goal named "A second goal" with the owner email "prem@test.com" belonging to the group called "Digital"
  When I sign in with the email "sonia@test.com"
  And I click on "Vision"
  And I click on "Sonia's new goal"
  And I click on "Sonia Price"
  Then I should see "Sonia's new goal"
  And I should NOT see "A second goal"

Scenario: If a user has no goals, display a message to that effect.
  Given I create a new non-admin named "Dweezil" with the email "dweezil@test.com"
  And I sign in using the email "dweezil@test.com"
  And I click on "Dweezil"
  Then I should see "Dweezil" within "h1"
  And I should see "owner" within "p"
  And I should see "This person does not own any goals in this system."
