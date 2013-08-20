Feature: Cart dishes

  In order to know what dishes I have bought
  A customer
  Wants the cart to list the dishes

  Background: Some dishes

    Given the dishes
      | Tomates farcies      | : | Tomates farcies congelées | Riz              |
      | Spaghetti bolognaise | : | Spaghetti                 | Sauce bolognaise |

  Scenario: Buying dishes

    When I buy the dishes
      | Tomates farcies      |
      | Spaghetti bolognaise |
    Then the cart should contain the items
      | Tomates farcies congelées |
      | Riz                       |
      | Spaghetti                 |
      | Sauce bolognaise          |
    And the cart should contain the dishes
      | Tomates farcies      |
      | Spaghetti bolognaise |

  Scenario: Buying the same dish many times

    When I buy the dishes
      | quantities | name            |
      |          2 | Tomates farcies |
    Then the cart should contain the items
      | quantities | name                      |
      |          2 | Tomates farcies congelées |
      |          2 | Riz                       |
    And the cart should contain the dishes
      | quantities | name            |
      |          2 | Tomates farcies |

  Scenario: Emptying a cart with dishes

    Given I bought the dishes
      | Tomates farcies      |
    When I empty the cart
    Then the cart should not contain any dish
