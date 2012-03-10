Feature: Places bar

  In order to know where he is in the site
  A customer
  Wants the current section at the top of the page to be styled

  Scenario: Place in dishes
    When  I go to the full dish catalog page
    Then  the place "Recettes" should be highlighted

  Scenario: Body id in cart
    When  I go to the cart page
    Then  the place "Panier" should be highlighted

  Scenario: Body id in root item category
    When  I go to the item categories page
    Then  the place "Ingrédients" should be highlighted

  Scenario: Body id when loging in
    When I go to the login page
    Then  the place "Connection" should be highlighted

  Scenario: Places bar before login
    When I go to the login page
    Then the places bar should contain a link "Connection" to the login page

  Scenario: Places bar after login
    When I log in
    Then the places bar should contain a link "Deconnection (email@email.com)" to logout

