Feature: Item organization

  In order to find specific items
  A customer
  Wants the items to be organized by type and sub category

  Scenario: Browsing an item category
    Given "Produits laitiers" item category
    And   I am on the item categories page
    When  I follow "Produits laitiers"
    Then  I should be on the "Produits laitiers" item category page

  Scenario: Browsing an item sub category
    Given "Produits laitiers > Fromages" item sub category
    And   I am on the "Produits laitiers" item category page
    When  I follow "Fromages"
    Then  I should be on the "Fromages" item sub category page
