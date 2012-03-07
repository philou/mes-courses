Feature: Item search

  In order to quickly find items that I want to buy
  A customer
  Wants a search by keyword tool within each category

  Scenario: Searching through all items
    Given there is a "Marché > Légumes > Tomates grappes" item
    And   there is a "Viandes > Plats préparés > Tomates farcies" item
    And   there is a "Produits congelés > Poisson > Coquilles St Jacques" item
    And   I am on the item categories page
    When  I search for "tomates"
    Then  I should see a "Tomates farcies" item
    And   I should see a "Tomates grappes" item
    And   I should not see a "Coquilles St Jacques" item

  Scenario: Searching from an item sub category
    Given there is a "Marché > Légumes > Tomates cerises" item
    And   there is a "Marché > Fruits > Cerises" item
    And   I am on the "Fruits" item sub category page
    When  I search for "cerises"
    Then  I should see a "Cerises" item
    And   I should not see a "Tomates cerises" item

  Scenario: Searching from an item category
    Given there is a "Marché > Légumes > Courgettes" item
    And   there is a "Viandes > Plats préparés > Courgettes farcies" item
    And   I am on the "Marché" item category page
    When  I search for "courgettes"
    Then  I should see a "Courgettes" item
    And   I should not see a "Courgettes farcies" item

  Scenario: Searching for something that does not exist
    Given there is a "Boucherie > Boeuf > Bavette" item
    And   I am on the item categories page
    When  I search for "homard"
    Then  I should see "0 ingrédients"

  Scenario: Searching with a plural word
    Given there is a "Marché > Fruits > Melon" item
    And   I am on the item categories page
    When  I search for "melons"
    Then  I should see a "Melon" item

  Scenario: Searching without accents
    Given there is a "Marché > Légumes > Taboulé" item
    And   I am on the item categories page
    When  I search for "taboule"
    Then  I should see a "Taboulé" item

  Scenario: Searching with multiple keywords
    Given there is a "Marché > Légumes > Petits pois" item
    And   there is a "Marché > Légumes > Carottes" item
    And   there is a "Surgelés > Légumes > Petits pois extra fins et carottes" item
    And   I am on the item categories page
    When  I search for "Petits pois carottes"
    Then  I should see "1 ingrédient"
    And   I should see a "Petits pois extra fins et carottes" item

  Scenario: Searching with different linking words
    Given there is a "Surgelés > Légumes > Petits pois, carottes" item
    And   I am on the item categories page
    When  I search for "Petits pois et carottes"
    Then  I should see a "Petits pois, carottes" item
