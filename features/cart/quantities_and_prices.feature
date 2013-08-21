Feature: Cart quantities and prices

  In order to know how much he will spend
  A customer
  Wants the cart to detail quantities and prices

  Background: Items for sale
    Given the items
      | name           | price |
      | PdT Charlottes | 2.5€  |
      | Bavette        | 4.0€  |
      | Tomates        | 2.4€  |


  Scenario: Different items are in the cart

    The cart total amount is the sum of the prices of all bought items.

    When I buy the items
      | PdT Charlottes |
      | Bavette        |
    Then the cart should contain the items
      | PdT Charlottes |
      | Bavette        |
    And the cart should amount to 6.5€


  Scenario: Many identical items are in the cart

    If bought multiple itmes, the cart amount is increased accordingly,
    and the number of items is reported in the cart.

    When I buy the items
      | quantity | name    |
      |        2 | Bavette |
    Then the cart should contain the items
      | quantity | name    |
      |        2 | Bavette |
    And the cart should amount to 8.0€


  Scenario: Emptying the cart

    The cart can be emptied of all its content.

    Given I bought the items
      | quantity | name    |
      |        2 | Bavette |
      |        1 | Tomates |
    When I empty the cart
    Then the cart should not contain any item
    And the cart should amount to 0.0€
