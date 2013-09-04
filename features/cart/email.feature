Feature: Cart email

  In order to remember what receipes I bought
  A customer
  Wants to receive an email with dishes and items details

  Background: Some dishes and a stores

    Given the "www.dummy-store.com" store
    And the dishes
      | Tomates farcies      | => | MEGA STORE, Tomates farcies congelées | UNCLE BOB, Riz            |             |
      | Spaghetti bolognaise | => | LAPASTA, Spaghetti                    | LAPASTA, Sauce bolognaise |             |
      | Spaghetti carbonara  | => | LAPASTA, Spaghetti                    | PORCIES, Lardons          | COWS, Crème |
    And I bought the dishes
      | Tomates farcies      |
      | Spaghetti bolognaise |
      | Spaghetti carbonara  |

  Scenario: Email after an order

    When I transfer my cart to the store, with account of email "valid@mail.com"
    Then I should receive "Les recettes de votre commande" at this email
"""
Tomates farcies
   * MEGA STORE, Tomates farcies congelées
   * UNCLE BOB, Riz
------------------------------------------------------------------------------
Spaghetti bolognaise
   * LAPASTA, Spaghetti
   * LAPASTA, Sauce bolognaise
------------------------------------------------------------------------------
Spaghetti carbonara
   * LAPASTA, Spaghetti
   * PORCIES, Lardons
   * COWS, Crème
------------------------------------------------------------------------------

Merci d'avoir commandé sur http://www.mes-courses.fr

Ceci est un email automatique, merci de ne pas répondre.
"""

  Scenario: No email if the transfer does not succeed

    When I try transfer my cart to the store, with wrong account of email "invalid@mail.com"
    Then I should not receive anything at this email
