# Copyright (C) 2010, 2011, 2012, 2013 by Philippe Bourgau

Feature: Incremental catalog import

  In order not to build its order by hand
  A customer
  Wants his available items to be automatically and regularly
    updated from the online store.

  Items needs to be tracked from one import to the next, so that
  dishes using them are kept correct.

  Scenario: Existing items are re-imported from the store
    Given the imported store "www.dummy-store.com"
    When "www.dummy-store.com" is imported again
    Then no new item should have been inserted
    And no item should have been modified
    And no item should have been deleted

  Scenario: Existing item categories and sub categories are re-imported from the store
    Given the imported store "www.dummy-store.com"
    When "www.dummy-store.com" is imported again
    Then  item organization should not have changed

  Scenario: New items are re-imported from the store
    Given the imported store "www.dummy-store.com"
    When the following items are added to "www.dummy-store.com"
      | Category | Sub category | Item       |
      | Marché   | Légumes      | Tomates    |
      | Marché   | Légumes      | Concombres |
    Then new items should have been inserted

  Scenario: Modified items are re-imported from the store
    Given the imported store "www.dummy-store.com"
    When "www.dummy-store.com" raises its prices
    Then some items should have been modified

  Scenario: Second import with sold out items

    If some items are not available from the remote store any more.
    They are shown disabled.

    Given the imported store "www.dummy-store.com" with items
      | Category | Sub category | Item       |
      | Marché   | Légumes      | Tomates    |
      | Marché   | Légumes      | Concombres |
      | Marché   | Légumes      | Radis      |
    And the dish "Salade de tomates" with items
      | Tomates |
    And an old order on "www.dummy-store.com" with
      | Item       | Quantity |
      | Concombres |        1 |
    When the following items are removed from "www.dummy-store.com"
      | Category | Sub category | Item    |
      | Marché   | Légumes      | Tomates |
      | Marché   | Légumes      | Concombres |
      | Marché   | Légumes      | Radis      |
    Then the following items should be disabled
      | Category | Sub category | Item       |
      | Marché   | Légumes      | Tomates    |
      | Marché   | Légumes      | Concombres |
    And the following items should have been deleted
      | Category | Sub category | Item  |
      | Marché   | Légumes      | Radis |

  Scenario: Second import with items that are available again

    Disabled items get re-enabled when they are back in the remote store.

    Given the imported store "www.dummy-store.com" with items
      | Category  | Sub category | Item        |
      | Marché    | Légumes      | Tomates     |
    And the dish "Salade de tomates" with items
      | Tomates |
    And the following items are disabled
      | Category | Sub category | Item    |
      | Marché   | Légumes      | Tomates |
    When "www.dummy-store.com" is imported again
    Then the following items should be enabled
      | Category | Sub category | Item    |
      | Marché   | Légumes      | Tomates |


