Feature: Catalog import

  In order to keep the item catalog up to date
  A webmaster
  Wants an automatic command to update the catalog from
   a remote online store

  Scenario: Items sold on an online store should be available
    Given an online store "www.auchandirect.fr"
    When products from the online store are imported
    Then there should be some items for sale

  Scenario: Items imported from an online store should be organized
    Given an online store "www.auchandirect.fr"
    When products from the online store are imported
    Then all items should be organized by type and subtype

  Scenario: Items imported from an online store should have a price
    Given an online store "www.auchandirect.fr"
    When products from the online store are imported
    Then all items should have a price

  Scenario: Most items imported from an online store should have an image
    Given an online store "www.auchandirect.fr"
    When products from the online store are imported
    Then most items should have an image

  Scenario: Most items imported from an online store should have a summary
    Given an online store "www.auchandirect.fr"
    When products from the online store are imported
    Then most items should have a summary
