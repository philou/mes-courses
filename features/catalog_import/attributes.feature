Feature: Catalog import attributes

  In order to have meaning full items for sale
  A webmaster
  Wants the import mechanism to import item details

  @deprecated
  Scenario: Items are imported with a price
    Given the "www.dummy-store.com" store
    When  items from the store are imported
    Then  all items should have a price

  @deprecated
  Scenario: Most items are imported with an image
    Given the "www.dummy-store.com" store
    When  items from the store are imported
    Then  most items should have an image

  @deprecated
  Scenario: Most items are imported with a brand
    Given the "www.dummy-store.com" store
    When  items from the store are imported
    Then  most items should have a brand
