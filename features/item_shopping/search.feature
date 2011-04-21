Feature: Item search

  In order to quickly find items that I want to buy
  A customer
  Wants a search by keyword tool within each category

  # Scenario: Searching through all items
  #   Given "Marché > Légumes > Tomates grappes" item
  #   And   "Viandes > Plats préparés > Tomates farcies" item
  #   And   "Produits congelés > Poisson > Coquilles St Jacques" item
  #   And   I am on the item categories page
  #   When  I search for "tomates"
  #   Then  I should see "Tomates farcies"
  #   And   I should see "Tomates grappes"
  #   And   I should not see "Coquilles St Jacques"

  # Scenario: Searching from an item sub category
  #   Given "Marché > Légumes > Tomates cerises" item
  #   And   "Marché > Fruits > Cerises" item
  #   And   I am on the "Fruits" item sub category page
  #   When  I search for "cerises"
  #   Then  I should see "Cerises"
  #   And   I should not see "Tomates cerises"

  # Scenario: Searching from an item category
  #   Given "Marché > Légumes > Courgettes" item
  #   And   "Viandes > Plats préparés > Courgettes farcies" item
  #   And   I am on the "Marché" item category page
  #   When  I search for "courgettes"
  #   Then  I should see "Courgettes"
  #   And   I should not see "Courgettes farcies"

  # Scenario: Searching for something that does not exist
  #   Given "Boucherie > Boeuf > Bavette" item
  #   And   I am on the item categories page
  #   When  I search for "homard"
  #   Then  I should see "Aucun produit n'a été trouvé"

