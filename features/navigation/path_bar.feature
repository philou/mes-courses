Feature: Path bar

  In order to know where he is in the site
  A customer
  Wants to have a path bar at the top of each page

  Scenario: Path bar in dishes
    When I go to the full dish catalog page
    Then The path bar should contain a link "Recettes" to the full dish catalog page

  Scenario: Path bar for new dishes
    When I go to the dish creation page
    Then The path bar should contain a link "Recettes" to the full dish catalog page
    And  The path bar should contain a link "Nouvelle recette" to the dish creation page

  Scenario: Path bar for existing dishes
    Given there is a dish "Lasagnes"
    When  I go to the "Lasagnes" dish page
    Then  The path bar should contain a link "Recettes" to the full dish catalog page
    And   The path bar should contain a link "Lasagnes" to the "Lasagnes" dish page

  Scenario: Path bar in cart
    When I go to the cart page
    Then The path bar should contain a link "Panier" to the cart page

  Scenario: Path bar when forwarding the cart
    Given the "www.dummy-store.fr" store with api
    And   I am on the cart page
    When  I forward the cart to the store account of a valid user
    Then  The path bar should contain a link "Panier" to the cart page
    And   The path bar should contain "Transfert"

  Scenario: Path bar in root item category
    When I go to the item categories page
    Then The path bar should contain a link "Ingrédients" to the item categories page

  Scenario: Path bar in child item categories
    Given there is a "Produits laitiers > Fromages" item sub category
    When  I go to the "Fromages" item sub category page
    Then  The path bar should contain a link "Ingrédients" to the item categories page
    And   The path bar should contain a link "Produits laitiers" to the "Produits laitiers" item category page
    And   The path bar should contain a link "Fromages" to the "Fromages" item sub category page

  Scenario: Path bar in item searches
    Given there is a "Produits laitiers" item category
    And   I am on the "Produits laitiers" item category page
    When  I search for "Camembert"
    Then  The path bar should contain a link "Ingrédients" to the item categories page
    And   The path bar should contain a link "Produits laitiers" to the "Produits laitiers" item category page
    And   The path bar should contain "Camembert"

