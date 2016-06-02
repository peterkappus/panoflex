Feature: Search for goals using freetext.

Scenario: Find a goal using keywords
  Given I create a goal named "Do something special" with the owner email "khalil@wherever.com" belonging to the group called "Digital"
  And I create a goal named "Do something ordinary" with the owner email "khalil@wherever.com" belonging to the group called "Digital"
  And I sign in as a non-admin named "Khalil" with the email "khalil@wherever.com"
  #test case insensitivity
  And I fill in "q" with "spEciAl"
  And I click "Search" within ".header-global"
  Then I should see "something special"
  #don't see goals that don't match
  And I should NOT see "ordinary"
