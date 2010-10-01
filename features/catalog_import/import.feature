Feature: Catalog import

  In order to keep the item catalog up to date
  A webmaster
  Wants an automatic command to update the catalog from
   a remote online store

  Scenario: Items sold on an online store should be available
    Given the "www.auchandirect.fr" online store
    When products from the store are imported
    Then there should be some items for sale
