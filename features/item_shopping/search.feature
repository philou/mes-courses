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
    Then  I should see "Tomates farcies"
    And   I should see "Tomates grappes"
    And   I should not see "Coquilles St Jacques"

  Scenario: Searching from an item sub category
    Given there is a "Marché > Légumes > Tomates cerises" item
    And   there is a "Marché > Fruits > Cerises" item
    And   I am on the "Fruits" item sub category page
    When  I search for "cerises"
    Then  I should see "Cerises"
    And   I should not see "Tomates cerises"

  Scenario: Searching from an item category
    Given there is a "Marché > Légumes > Courgettes" item
    And   there is a "Viandes > Plats préparés > Courgettes farcies" item
    And   I am on the "Marché" item category page
    When  I search for "courgettes"
    Then  I should see "Courgettes"
    And   I should not see "Courgettes farcies"

  Scenario: Searching for something that does not exist
    Given there is a "Boucherie > Boeuf > Bavette" item
    And   I am on the item categories page
    When  I search for "homard"
    Then  I should see "0 ingrédient(s)"

