Feature: Places bar

  In order to know where he is in the site
  A customer
  Wants the current section at the top of the page to be styled

  Scenario: Dish place
    When I go to the full dish catalog page
    Then the place "Recettes" should be highlighted

  Scenario: Cart place
    When I go to the cart page
    Then the place "Panier" should be highlighted

  Scenario: Item place
    When I go to the item categories page
    Then the place "Ingrédients" should be highlighted

  Scenario: Login place
    When I go to the login page
    Then  the place "Connection" should be highlighted
    And the places bar should contain a link "Connection" to the login page

  Scenario: Logout place
    When I log in
    Then the places bar should contain a link "Deconnection (email@email.com)" to logout

