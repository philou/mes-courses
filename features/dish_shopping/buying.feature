Feature: Dish buying

  In order to buy all the items to cook a dish
  A customer
  Wants to add all the ingredient of a dish to its caddy

  Scenario: It should be possible to add all ingredients of a dish to the cart
    Given "Pates au Saumon" is a known dish
    And   I am on the full dish catalog page
    When  I follow "Ajouter au panier"
    Then  There should be "Pates" in my cart
    And   There should be "Saumon" in my cart
