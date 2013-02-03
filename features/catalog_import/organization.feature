# Copyright (C) 2011-2013 by Philippe Bourgau

Feature: Catalog import organization

  In order to be able to manage the quantity of imported item
  A webmaster
  Wants the import mechanism to organize items into types and
   sub categories.

  @deprecated
  Scenario: Items import organizes the items by category
    Given the "www.dummy-store.com" store
    When  items from the store are imported
    Then  all items should be organized by type and subtype

  Scenario: Items import deletes empty categories

    After import, the categories that don't contain any
    items are deleted.

    Given the imported store "www.dummy-store.com" with items
      | Category  | Sub category | Item        |
      | Marché    | Légumes      | Tomates     |
    When the following items are removed from "www.dummy-store.com"
      | Category | Sub category | Item    |
      | Marché   | Légumes      | Tomates |
    Then the following categories should have been deleted
      | Légumes |
      | Marché  |
