Feature: Item organization

  In order to find specific items
  A customer
  Wants the items to be organized by type and sub type

  Scenario: There should be links to individual item types
    Given "Produits laitiers" item type
    And   I am on the item types page
    When  I follow "Produits laitiers"
    Then  I should be on the "Produits laitiers" item type page

  Scenario: There should be links from an item type to its item sub types
    Given "Produits laitiers > Fromages" item sub type
    And   I am on the "Produits laitiers" item type page
    When  I follow "Fromages"
    Then  I should be on the "Fromages" item sub type page
