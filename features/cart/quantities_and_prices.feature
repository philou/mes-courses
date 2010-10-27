Feature: Cart quantities and prices

  In order to know how much he will spend
  A customer
  Wants the cart to detail quantities and prices

  Scenario: Different items are in the cart
    Given "Fruits & Légumes > Pommes de terre > PdT Charlottes" item at 2.5€
    And   "Viandes > Boeuf > Bavette" item at 4.0€
    And   There are "PdT Charlottes" in the cart
    And   There is "Bavette" in the cart
    When  I go to the cart page
    Then  I should see "6.5€"

  Scenario: Many identical items are in the cart
    And   "Viandes > Boeuf > Bavette" item at 3.0€
    And   There are 2 "Bavette" in the cart
    When  I go to the cart page
    Then  I should see "2"
    And   I should see "6.0€"

