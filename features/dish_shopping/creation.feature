Feature: Dish creation

  In order to save time next time
  A customer
  Wants to add his own dishes

  Scenario: Default name of a new dish
    Given I am logged in
    And   I am on the full dish catalog page
    When  I follow "Ajouter une recette"
    Then  the "name" field of the "dish" should be "Nouvelle recette"

  Scenario: Creating a new dish
    Given I am logged in
    And   I am on the dish creation page
    When  I set the dish name to "Salade de tomates"
    Then  I should be on the "Salade de tomates" dish page
    And   I should see "Salade de tomates"

  Scenario: Shopping a newly created dish
    Given I am logged in
    And   I am on the dish creation page
    When  I set the dish name to "Salade niçoise"
    And   I go to the full dish catalog page
    Then  I should see "Salade niçoise"

  Scenario: Browsing items for a dish
    Given there is a "Marché" item category
    And   there is a "Boucherie" item category
    And   there is a dish "Lasagnes"
    And   I am logged in
    And   I am on the "Lasagnes" dish page
    When  I follow "Ajouter un ingrédient"
    Then  I should see "Marché"
    And   I should see "Boucherie"

  Scenario: Adding an item to a dish
    Given there is a "Poissonerie > Poissons de mer > Colin" item
    And   there is a dish "Poissons panés"
    And   I am logged in
    And   I am on the "Poissons panés" dish "Poissons de mer" item category page
    When  I press "Ajouter à la recette"
    Then  I should be on the "Poissons panés" dish page
    And   I should see "Colin"

  Scenario: Removing an item from a dish
    Given there is a dish "Agneau aux flageolets"
    And   I am logged in
    And   I am on the "Agneau aux flageolets" dish page
    When  I remove "Agneau" from the dish
    Then  I am on the "Agneau aux flageolets" dish page
    And   I should see "1 ingrédient"
    And   I should not see an "Agneau" item
