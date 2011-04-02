Feature: Cart Forwarding

  In order to be delivered my items
  A customer
  Wants the cart to detail quantities and prices

  Scenario: An empty cart is forwarded to the store
    Given the "www.dummy-store.fr" store with api
    And   I am on the cart page
    When  I forward the cart to the store account of a valid user
    Then  an empty cart should be created in the store account of the user

  Scenario: A real cart is forwarded to the store
    Given the "www.dummy-store.fr" store with api
    And   "Fruits & Légumes > Pommes de terre > PdT Charlottes" item at 2.5€
    And   There are "PdT Charlottes" in the cart
    And   I am on the cart page
    When  I forward the cart to the store account of a valid user
    Then  a non empty cart should be created in the store account of the user

  Scenario: A customer is redirected to a report page after his cart is forwarded
    Given the "www.dummy-store.fr" store with api
    And   I am on the cart page
    When  I forward the cart to the store account of a valid user
    Then  I should see "Votre panier a été transféré à 'www.dummy-store.fr'"
    And   "Retour au panier" should link to the cart page
    And   "Payer sur 'www.dummy-store.fr'" should link to the "www.dummy-store.fr" website

  Scenario: Failure due to invalid login-password
    Given the "www.dummy-store.fr" store with api
    And   I am on the cart page
    When  I forward the cart to the store account of an invalid user
    Then  I should be on the cart page
    And   I should see "Désolé, nous n'avons pas pu vous connecter à 'www.dummy-store.fr'. Vérifiez vos identifiant et mot de passe."

  Scenario: A cart with unavailable items is forwarded to the store
    Given the "www.dummy-store.fr" store with api
    And   "Fruits & Légumes > Pommes de terre > PdT Charlottes" item at 2.5€
    And   There are "PdT Charlottes" in the cart
    And   "PdT Charlottes" are unavailable in the store
    And   I am on the cart page
    When  I forward the cart to the store account of a valid user
    Then  I should see "Nous n'avons pas pu ajouter 'PdT Charlottes' à votre panier sur 'www.dummy-store.fr' parce que cela n'y est plus disponible"

