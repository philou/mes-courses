Feature: Per dish shopping

  In order to buy all the items to cook a dish
  A customer
  Wants to browse and add to its caddy any known dish

  Scenario: Known dishes should be displayed
    Given "Steak au poivre" is a known dish
    When  I go to the full dish catalog page
    Then  I should see "Steak au poivre"


  Scenario: It should be possible to add all ingredients of a dish to the cart
    Given "Pates au Saumon" is a known dish
    And   I am on the full dish catalog page
    When  I follow "Ajouter au panier"
    Then  There should be "Pates" in my cart
     And  There should be "Saumon" in my cart
