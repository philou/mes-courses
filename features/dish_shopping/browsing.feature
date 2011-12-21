Feature: Dish browsing

  In order to find what he wants to eat
  A customer
  Wants to browse known dishes

  Scenario: Browsing available dishes
    Given there is a dish "Steak au poivre"
    And   I am logged in
    When  I go to the full dish catalog page
    Then  I should see "Steak au poivre"

  Scenario: Getting details about a dish
    Given there is a dish "Cabillaud roti"
    And   I am logged in
    And   I am on the full dish catalog page
    When  I follow "Cabillaud roti"
    Then  I should be on the "Cabillaud roti" dish page
