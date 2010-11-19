Feature: Item organization

  In order to find specific items
  A customer
  Wants the items to be organized by type and sub category

  Scenario: There should be links to individual item categories
    Given "Produits laitiers" item category
    And   I am on the item categories page
    When  I follow "Produits laitiers"
    Then  I should be on the "Produits laitiers" item category page

  Scenario: There should be links from an item category to its sub categories
    Given "Produits laitiers > Fromages" item sub category
    And   I am on the "Produits laitiers" item category page
    When  I follow "Fromages"
    Then  I should be on the "Fromages" item sub category page
