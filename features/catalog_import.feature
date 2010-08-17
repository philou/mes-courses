Feature: Catalog import

  In order to keep the item catalog up to date
  A webmaster
  Wants an automatic command to update the catalog from
   a remote online store

  Scenario: Items sold on an online store should be available
    Given an online store "http://www.auchandirect.fr"
    When products from the online store are imported
    Then there should be some items for sale

