Feature: Not logged in dish shopping

  In order to control what is done on the site
  A webmaster
  Wants to disabled dish modifications by unknown users

  Scenario: Cannot create dishes
    Given I am not logged in
    And   I am on the full dish catalog page
    Then  I should not see "Ajouter une recette"

  Scenario: Cannot add items to a dish
    Given there is a dish "Lasagnes"
    And   I am not logged in
    When  I am on the "Lasagnes" dish page
    Then  I should not see "Ajouter un ingrédient"

  Scenario: Cannot remove items from a dish
    Given there is a dish "Agneau aux flageolets"
    And   I am not logged in
    When  I am on the "Agneau aux flageolets" dish page
    Then  I should not see "Enlever de la recette"
