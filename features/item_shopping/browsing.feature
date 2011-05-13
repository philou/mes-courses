Feature: Item browsing

  In order to know what is a specific item
  A customer
  Wants to browse it and its details

  Scenario: Browsing items in their sub category page
    Given "Fruits & Légumes > Tomates > Tomates grappes" item
    When  I go to the "Tomates" item sub category page
    Then  I should see "Tomates grappes"

  Scenario: Browsing price, summary and photos of items
    Given "Fruits & Légumes > Pommes de terre > PdT Charlottes" item
    When   I go to the "Pommes de terre" item sub category page
    Then   I should see the "price" of "PdT Charlottes"
    And    I should see the "summary" of "PdT Charlottes"
    And    I should see the "image" of "PdT Charlottes" as img
