Feature: Per item shopping

  In order to buy a specific item
  A customer
  Wants to browse and add to its caddy any available item

  Scenario: Available items should be displayed
    Given "Tomates" for sale
    When  I go to the full item catalog page
    Then  I should see "Tomates"

  Scenario: It should be possible to add items to the cart
    Given "Pommes de terre" for sale
    And   I am on the full item catalog page
    When  I follow "Ajouter au panier"
    Then  There should be "Pommes de terre" in my cart
