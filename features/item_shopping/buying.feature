Feature: Item buying

  In order to buy a specific item
  A customer
  Wants to its cart any available item

  Scenario: Adding an item to the cart
    Given the item "PdT Charlottes"
    When I buy the item "PdT Charlottes"
#    Then I should get a confirmation that I bought the item "PdT Charlottes"
    Then the cart should contain the item "PdT Charlottes"

