Feature: Item buying

  In order to buy a specific item
  A customer
  Wants to its cart any available item

  Scenario: It should be possible to add items to the cart
    Given "Fruits & Légumes > Pommes de terre > PdT Charlottes" item
    And   I am on the "Pommes de terre" item sub category page
    When  I follow "Ajouter au panier"
    Then  There should be "PdT Charlottes" in my cart

