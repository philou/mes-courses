Feature: Per item shopping

  In order to buy a specific item
  A customer
  Wants to browse and add to its caddy any available item

  Scenario: Available items should be displayed
    Given tomatoes for sale
    When I go to the full item catalog page
    Then I should see "Tomatoes"

