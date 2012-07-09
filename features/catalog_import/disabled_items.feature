# Copyright (C) 2011, 2012 by Philippe Bourgau

Feature: Handling disabled items in import

  In order to have full dishes
  A customer
  Wants dishes to be updated when one of their item is removed from the store

  After an import, dishes with sold out items are disabled. A notification email is also
  sent to the webmaster so that he can fix the dishes.

  Background:
    Given the imported store "www.dummy-store.com" with items
      | Category  | Sub category | Item        |
      | Marché    | Légumes      | Tomates     |
      | Boucherie | Boeuf        | Boeuf haché |
    And the dish "Tomates farcies" with items
      | Tomates     |
      | Boeuf haché |

  Scenario: During an import, a dish is broken by a sold out item

    If an item used in a dish is disabled after an import, some dishes
    requirering it might get broken. An email is sent to the maintainer,
    and the dishes are disabled.

    When the following items are removed from "www.dummy-store.com"
      | Category | Sub category | Item    |
      | Marché   | Légumes      | Tomates |
    Then a broken dishes report email should be sent to the maintainer with
      | Broken dish     | Disabled item |
      | Tomates farcies | Tomates       |
    And the dish "Tomates farcies" should still have items
      | Tomates |
#    But the dish "Tomates farcies" should be disabled

  Scenario: A broken dish gets fixed when a sold out item is available again

    Dishes get automaticaly fixed when a sold out item is in stock again
    in the remote store.

    Given the following items are disabled
      | Category | Sub category | Item    |
      | Marché   | Légumes      | Tomates |
    When "www.dummy-store.com" is imported again
    Then the dish "Tomates farcies" should be enabled
