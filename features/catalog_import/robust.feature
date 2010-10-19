# Copyright (C) 2010 by Philippe Bourgau

Feature: Robust catalog import

  In order to handle unexpected production problems
  A webmaster
  Wants the import to resumed where it was stopped

  Scenario: Items are reimported after a interrupted import
    Given the "www.auchandirect.fr" store
    And   last store import was unexpectedly interrupted
    When  modified items from the store are re-imported
    Then  new items should have been inserted
    And   existing items should not have been modified
