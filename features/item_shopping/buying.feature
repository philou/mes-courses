Feature: Item buying

  In order to buy a specific item
  A customer
  Wants to its cart any available item

  Scenario: Adding an item to the cart
    Given there is a "Fruits & Légumes > Pommes de terre > PdT Charlottes" item
    And   I am on the "Pommes de terre" item sub category page
    When  I follow "Ajouter au panier"
    Then  there should be "PdT Charlottes" in my cart

