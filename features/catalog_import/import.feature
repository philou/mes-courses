Feature: Catalog import

  In order to keep the item catalog up to date
  A webmaster
  Wants an automatic command to update the catalog from
   a remote online store

  Scenario: Importing items sold on a store
    Given the "www.dummy-store.com" store
    When  items from the store are imported
    Then  there should be some items for sale
