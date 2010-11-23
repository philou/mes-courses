# Copyright (C) 2010 by Philippe Bourgau

Feature: Incremental catalog import

  In order not to build its order by hand
  A customer
  Wants available items to be automatically and regularly
    updated from the online store.

  Scenario: Existing items are re-imported from the store
    Given the "www.auchandirect.fr" store
    And   items from the store were already imported
    When  items from the store are re-imported
    Then  no new item should have been inserted
    And   no item should have been modified
    And   no item should have been deleted

  Scenario: New items are re-imported from the store
    Given the "www.auchandirect.fr" store
    And   items from the store were already imported
    When  more items from the store are re-imported
    Then  new items should have been inserted

  Scenario: Modified items are re-imported from the store
    Given the "www.auchandirect.fr" store
    And   items from the store were already imported
    When  modified items from the store are re-imported
    Then  some items should have been modified

  Scenario: Sold out items are re-imported from the store
    Given the "www.auchandirect.fr" store
    And   items from the store were already imported
    When  sold out items from the store are re-imported
    Then  some items should have been deleted

  Scenario: Existing item categories and sub categories are re-imported from the store
    Given the "www.auchandirect.fr" store
    And   items from the store were already imported
    When  items from the store are re-imported
    Then  item organization should not have changed

  Scenario: Emptied item categories and sub categories are re-imported from the store
    Given the "www.auchandirect.fr" store
    And   items from the store were already imported
    When  sold out items from the store are re-imported
    Then  item organization should have shrank