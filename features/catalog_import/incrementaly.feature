# Copyright (C) 2010 by Philippe Bourgau

Feature: Incremental catalog import

  In order not to build its order by hand
  A customer
  Wants available items to be automatically and regularly
    updated from the online store.

  Scenario: Re-importing unmodified items
    Given an online store "www.auchandirect.fr"
    And   products from the online store were already imported
    When  products from the online store are re-imported
    Then  no new item should have been inserted
    And   no item should have been modified
    And   no item should have been deleted
