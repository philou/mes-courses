Feature: Dish creation

  In order to save time next time
  A customer
  Wants to add his own dishes

  Scenario: Creating a new dish
    Given I am on the full dish catalog page
    When  I follow "Ajouter une recette"
    Then  the "name" field of the "dish" should be "Nouvelle recette"

  Scenario: Creating a new dish
    Given I am on the dish creation page
    When  I set the dish name to "Salade de tomates"
    Then  I should be on the "Salade de tomates" dish page
    And   I should see "Salade de tomates"

  Scenario: Shopping a new dish
    Given I am on the dish creation page
    When  I set the dish name to "Salade niçoise"
    And   I go to the full dish catalog page
    Then  I should see "Salade niçoise"

  # Scenario: Browsing items for a dish
  #   Given there is a "Marché" item category
  #   And   there is a "Boucherie" item category
  #   And   there is a dish "Lasagnes"
  #   And   I am on the "Lasagnes" dish page
  #   When  I follow "Ajouter un ingrédient"
  #   Then  I should see a link "Marché"
  #   And   I should see a link "Boucherie"

  # Scenario: Adding an item to a dish
  #   Given there is a "Poissonerie > Poissons de mer > Colin" item
  #   And   I am creating the dish "Poissons panés"
  #   And   I am adding a new item to the dish
  #   When  I follow "Poissons de mer"
  #   And   I follow "Ajouter à la recette"
  #   Then  I should be on the "Poissons panés" dish page
  #   And   I should see "Colin"

