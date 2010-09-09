Feature: Per item shopping

  In order to buy a specific item
  A customer
  Wants to browse and add to its caddy any available item

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

  Scenario: Available items should be displayed in their item sub type
    Given "Fruits & Légumes > Tomates > Tomates grappes" item
    When  I go to the "Tomates" item sub type page
    Then  I should see "Tomates grappes"

  Scenario: It should be possible to add items to the cart
    Given "Fruits & Légumes > Pommes de terre > PdT Charlottes" item
    And   I am on the "Pommes de terre" item sub type page
    When  I follow "Ajouter au panier"
    Then  There should be "PdT Charlottes" in my cart
