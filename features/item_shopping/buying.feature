Feature: Item buying

  In order to buy a specific item
  A customer
  Wants to its cart any available item

  Scenario: Adding an item to the cart
    Given an item "PdT Charlottes"
    When I buy this item
#    Then I should get a confirmation that I bought this item
    Then the cart should contain this item

