Feature: Cart Checkout

  In order to be delivered his items
  A customer
  Wants to checkout his cart to a real store

  Scenario: An empty cart is forwarded to the store
    Given the "www.dummy-store.com" store
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    And   I wait for the transfer to end
    Then  an empty cart should be created in the store account of the user

  Scenario: A real cart is forwarded to the store
    Given the "www.dummy-store.com" store
    And   there is a "Fruits & Légumes > Pommes de terre > PdT Charlottes" item at 2.5€
    And   there are "PdT Charlottes" in the cart
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    And   I wait for the transfer to end
    Then  a non empty cart should be created in the store account of the user

  Scenario: Failure due to invalid login-password
    Given the "www.dummy-store.com" store
    And   I am on the cart page
    And   I entered invalid store account identifiers
    When  I press "Transférer le panier"
    And   I wait for the transfer to end
    Then  I should be on the cart page
    And   I should see "Désolé, nous n'avons pas pu vous connecter à 'www.dummy-store.com'. Vérifiez vos identifiant et mot de passe."

  Scenario: A cart with unavailable items is forwarded to the store
    Given the "www.dummy-store.com" store
    And   there is a "Fruits & Légumes > Pommes de terre > PdT Charlottes" item at 2.5€
    And   "PdT Charlottes" are unavailable in the store
    And   there are "PdT Charlottes" in the cart
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    And   I wait for the transfer to end
    Then  there should be a warning about the unavailability of "PdT Charlottes" in "www.dummy-store.com"
