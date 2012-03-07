Feature: Cart quantities and prices

  In order to know how much he will spend
  A customer
  Wants the cart to detail quantities and prices

  Scenario: Different items are in the cart
    Given there is a "Fruits & Légumes > Pommes de terre > PdT Charlottes" item at 2.5€
    And   there is a "Viandes > Boeuf > Bavette" item at 4.0€
    And   there are "PdT Charlottes" in the cart
    And   there is "Bavette" in the cart
    When  I go to the cart page
    Then  I should see "PdT Charlottes"
    And   I should see "Bavette"
    And   I should see "6.5€"

  Scenario: Many identical items are in the cart
    Given there is a "Viandes > Boeuf > Bavette" item at 3.0€
    And   there are 2 "Bavette" in the cart
    When  I go to the cart page
    Then  I should see "2"
    And   I should see "6.0€"

  Scenario: Emptying the cart
    Given there is a "Viandes > Boeuf > Bavette" item at 3.0€
    And   there is a "Marché > Légumes > Tomates" item at 2.4€
    And   there are 2 "Bavette" in the cart
    And   there are 1 "Tomates" in the cart
    And   I am on the cart page
    When  I press "Vider le panier"
    Then  I should not see "Tomates"
    And   I should not see "Bavette"
    And   I should see "0€"
