Feature: Dish buying

  In order to buy all the items to cook a dish
  A customer
  Wants to add all the ingredient of a dish to its caddy

  Scenario: Adding a dish to the cart
    Given the dish "Pates au saumon"
    When  I buy the dish "Pates au saumon"
#    Then I should get a confirmation that I bought the dish "Pates au saumon"
    Then  the cart should contain the dish "Pates au saumon"
