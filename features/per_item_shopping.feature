Feature: Per item shopping

  In order to buy a specific item
  A customer
  Wants to browse and add to its caddy any available item

  Scenario: Available items should be displayed
    Given "Tomates" for sale
    When  I go to the full item catalog page
    Then  I should see "Tomates"
    # Given "Fruits & Légumes > Tomates > Tomates grappes" for sale
    # When  I go to the "Fruits & Légumes > Tomates" item sub type page
    # Then  I should see "Tomates grappes"

  Scenario: It should be possible to add items to the cart
    Given "Pommes de terre" for sale
    And   I am on the full item catalog page
    When  I follow "Ajouter au panier"
    Then  There should be "Pommes de terre" in my cart
    # Given "Fruits & Léguumes > Pommes de terre > PdT Charlottes" for sale
    # And   I am on the "Fruits & Légumes > Pommes de terre" item sub type page
    # When  I follow "Ajouter au panier"
    # Then  There should be "PdT Charlottes" in my cart

  Scenario: Available items should be displayed through their type
    Given "Produits laitiers" item type
    When  I go to the item types page
    Then  I should see "Produits laitiers"

  Scenario: There should be links to item types
    Given "Produits laitiers" item type
    And   I am on the item types page
    When  I follow "Produits laitiers"
    Then  I should be on the "Produits laitiers" item type page

  Scenario: Available items should be displayed through their sub types
    Given "Produits laitiers > Fromages" item sub type
    When  I go to the "Produits laitiers" item type page
    Then  I should see "Fromages"

  # there should be links to items

