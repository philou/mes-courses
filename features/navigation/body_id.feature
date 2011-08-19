Feature: Body id

  In order to know where he is in the site
  A customer
  Wants the current section at the top of the page to be styled

  Scenario: Body id in dishes
    When I go to the full dish catalog page
    Then the body id should be "dish"

  Scenario: Body id in cart
    When I go to the cart page
    Then the body id should be "cart"

  Scenario: Body id in root item category
    When I go to the item categories page
    Then the body id should be "items"

