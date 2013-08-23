Feature: Dish buying

  In order to buy all the items to cook a dish
  A customer
  Wants to add all the ingredient of a dish to its caddy

  Scenario: Adding a dish to the cart
    Given a dish "Pates au saumon"
    When I buy this dish
    Then I should get a confirmation that I bought this dish
    And the cart should contain this dish
