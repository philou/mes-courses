Feature: Catalog import organization

  In order to be able to manage the quantity of imported item
  A webmaster
  Wants the import mechanism to organize items into types and
   sub categories.

  Scenario: Items import organizes the items by category
    Given the "www.auchandirect.fr" store
    When items from the store are imported
    Then all items should be organized by type and subtype
