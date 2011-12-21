Feature: Dish buying

  In order to buy all the items to cook a dish
  A customer
  Wants to add all the ingredient of a dish to its caddy

  Scenario: Adding a dish to the cart
    Given there is a dish "Pates au Saumon"
    And   I am logged in
    And   I am on the full dish catalog page
    When  I press "Ajouter au panier"
    Then  there should be "Pates" in my cart
    And   there should be "Saumon" in my cart
