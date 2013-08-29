Feature: Cart email

  In order to remember what receipes I bought
  A customer
  Wants to receive an email with dishes and items details

  Background: Some dishes in my cart

    Given the dishes
      | Tomates farcies      | => | Tomates farcies congelées | Riz              |       |
      | Spaghetti bolognaise | => | Spaghetti                 | Sauce bolognaise |       |
      | Spaghetti carbonara  | => | Spaghetti                 | Lardons          | Crème |
    And I bought the dishes
      | Tomates farcies      |
      | Spaghetti bolognaise |
      | Spaghetti carbonara  |

  Scenario: Email after an order

    When I transfer my cart to the store, with account email "valid@mail.com"
    Then I should receive "Les recettes de votre commande" at this email
"""
------------------------------------------------------------------------------
Tomates farcies
   * Tomates farcies congelées
   * Riz
------------------------------------------------------------------------------
Spaghetti bolognaise
   * Spaghetti
   * Sauce bolognaise
------------------------------------------------------------------------------
Spaghetti carbonara
   * Spaghetti
   * Lardons
   * Crème

------------------------------------------------------------------------------
Merci d'avoir commandé sur http://www.mes-courses.fr

Ceci est un email automatique, ne pas répondre.
"""

  Scenario: No email if the transfer does not succeed

    When I transfer my cart to the store, with account email "invalid@mail.com"
    Then I should not receive anything at this email
