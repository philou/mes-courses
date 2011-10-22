# Copyright (C) 2010, 2011 by Philippe Bourgau

Feature: Robust catalog import

  In order to handle unexpected production problems
  A webmaster
  Wants the import to resumed where it was stopped

  Scenario: Items are reimported after an interrupted import
    Given the "www.dummy-store.com" store
    And   last store import was unexpectedly interrupted
    When  modified items from the store are re-imported
    Then  new items should have been inserted
    And   existing items should not have been modified

  Scenario: Import retries on network error
    Given the "www.dummy-store.com" store
    And   the network connection is unstable
    When  items from the store are imported
    Then  all items from the store should have been imported

