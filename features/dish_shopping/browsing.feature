Feature: Dish browsing

  In order to find what he wants to eat
  A customer
  Wants to browse known dishes

  Scenario: Browsing available dishes
    Given "Steak au poivre" is a known dish
    When  I go to the full dish catalog page
    Then  I should see "Steak au poivre"
