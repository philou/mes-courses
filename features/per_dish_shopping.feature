Feature: Per dish shopping

  In order to buy all the items to cook a dish
  A customer
  Wants to browse and add to its caddy any known dish

  Scenario: Known dishes should be displayed
    Given "Tomates farcies" is a known dish
    When  I go to the full dish catalog page
    Then  I should see "Tomates farcies"
