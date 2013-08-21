Feature: Item buying

  In order to buy a specific item
  A customer
  Wants to its cart any available item

  Scenario: Adding an item to the cart
    Given the items
      | PdT Charlottes |
    When I buy the items
      | PdT Charlottes |
#    Then I should get a confirmation that I bought the items
#      | PdT Charlottes |
    Then the cart should contain the items
      | PdT Charlottes |

