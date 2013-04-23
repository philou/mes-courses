Feature: Catalog import attributes

  In order to have meaning full items for sale
  A webmaster
  Wants the import mechanism to import item details

  Scenario: Items are imported with a price
    Given the unimported store "www.dummy-store.com" with items
      | Category | Sub category | Item        | Price |
      | Marché   | Légumes      | Petits pois |   1.9 |
      | Marché   | Boucherie    | Poulet      |   5.3 |
    When "www.dummy-store.com" is imported
    Then all items should have a price
    And there should be the following items
      | Category | Sub category | Item        | Price |
      | Marché   | Légumes      | Petits pois |   1.9 |
      | Marché   | Boucherie    | Poulet      |   5.3 |

  Scenario: Most items are imported with an image
    Given the unimported store "www.dummy-store.com" with items
      | Category | Sub category | Item        | Image       |
      | Marché   | Légumes      | Petits pois | pp.jpg      |
      | Marché   | Boucherie    | Poulet      | chicken.jpg |
    When "www.dummy-store.com" is imported
    Then  most items should have an image
    And there should be the following items
      | Category | Sub category | Item        | Image       |
      | Marché   | Légumes      | Petits pois | pp.jpg      |
      | Marché   | Boucherie    | Poulet      | chicken.jpg |

  Scenario: Most items are imported with a brand
    Given the unimported store "www.dummy-store.com" with items
      | Category | Sub category | Item        | Brand  |
      | Marché   | Légumes      | Petits pois | Auchan |
      | Marché   | Boucherie    | Poulet      | Charal |
    When "www.dummy-store.com" is imported
    Then  most items should have a brand
    And there should be the following items
      | Category | Sub category | Item        | Brand  |
      | Marché   | Légumes      | Petits pois | Auchan |
      | Marché   | Boucherie    | Poulet      | Charal |
