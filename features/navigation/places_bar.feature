Feature: Places bar

  In order to know where he is in the site
  A customer
  Wants the current section at the top of the page to be styled

  Scenario: Body id in dishes
    Given I am logged in
    When  I go to the full dish catalog page
    And   I go to the full dish catalog page
    Then  the body id should be "dish"

  Scenario: Body id in cart
    Given I am logged in
    When  I go to the cart page
    Then  the body id should be "cart"

  Scenario: Body id in root item category
    Given I am logged in
    When  I go to the item categories page
    Then  the body id should be "items"

  Scenario: Body id when loging in
    When I go to the login page
    Then the body id should be "session"

  Scenario: Places bar before login
    When I go to the login page
    Then the places bar should contain a link "Connection" to the login page

  Scenario: Places bar after login
    When I log in
    Then the places bar should contain a link "Deconnection (email@email.com)" to logout

