Feature: Item browsing

  In order to know what is a specific item
  A customer
  Wants to browse it and its details

  # REM if we create a custom display for individual items, this could be moved to organization
  Scenario: Available items should be displayed in their item sub type
    Given "Fruits & Légumes > Tomates > Tomates grappes" item
    When  I go to the "Tomates" item sub type page
    Then  I should see "Tomates grappes"

  Scenario: Items should have a price, a summary and a photo
    Given "Fruits & Légumes > Pommes de terre > PdT Charlottes" item
    When   I go to the "Pommes de terre" item sub type page
    Then   I should see the "price" of "PdT Charlottes"
    And    I should see the "summary" of "PdT Charlottes"
    And    I should see the "image" of "PdT Charlottes" as img
