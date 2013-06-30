Feature: Catalog import

  In order to keep the item catalog up to date
  A webmaster
  Wants an automatic command to update the catalog from
   a remote online store

  Scenario: Importing items sold on a store
    Given the unimported store "www.dummy-store.com"
    When  "www.dummy-store.com" is imported
    Then  all items from "www.dummy-store.com" should have been imported

  Scenario: Importing items with the same name
    Given the unimported store "www.dummy-store.com" with items
      | Category | Sub category | Item        |
      | Marché   | Légumes      | Petits pois |
      | Surgelés | Légumes      | Petits pois |
    When  "www.dummy-store.com" is imported
    Then  there should be 2 different items with name "Petits pois" for sale
