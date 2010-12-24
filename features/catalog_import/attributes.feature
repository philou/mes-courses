Feature: Catalog import attributes

  In order to have meaning full items for sale
  A webmaster
  Wants the import mechanism to import item details

  Scenario: Items imported from a store should have a price
    Given the "www.auchandirect.fr" store
    When items from the store are imported
    Then all items should have a price

  Scenario: Most items imported from a store should have an image
    Given the "www.auchandirect.fr" store
    When items from the store are imported
    Then most items should have an image

  Scenario: Most items imported from a store should have a summary
    Given the "www.auchandirect.fr" store
    When items from the store are imported
    Then most items should have a summary
