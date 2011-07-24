# Copyright (C) 2011 by Philippe Bourgau

Feature: Handling deleted items in import

  In order to have full dishes
  A customer
  Wants dishes to be updated when one of their item is removed from the store

  Scenario: Browsing a dish just after the item was removed
    Given the "www.dummy-store.com" store
    And   items from the store were already imported
    And   a dish "Quiche lorraine" with "Lait entier"
    And   "Lait entier" was removed from the store
    When  items from the store are re-imported
    And   I go to the "Quiche lorraine" dish page
    Then  I should not see "Lait demi écrémé"

  Scenario: Emailing the webmaster when a used item is removed from a dish
    Given the "www.dummy-store.com" store
    And   items from the store were already imported
    And   a dish "Quiche lorraine" with "Lait entier"
    And   "Lait entier" was removed from the store
    When  items from the store are re-imported
    Then  an email ~"broken dishes" containing "Quiche lorraine" and "Lait entier" should be sent to the maintainer
