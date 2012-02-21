Feature: Cart Forwarding

  In order to be delivered his items
  A customer
  Wants to forward his cart to a real store

  Scenario: An empty cart is forwarded to the store
    Given the "www.dummy-store.com" store
    And   I am logged in
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    And   I wait for the transfer to end
    Then  an empty cart should be created in the store account of the user

  Scenario: A real cart is forwarded to the store
    Given the "www.dummy-store.com" store
    And   there is a "Fruits & Légumes > Pommes de terre > PdT Charlottes" item at 2.5€
    And   I am logged in
    And   there are "PdT Charlottes" in the cart
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    And   I wait for the transfer to end
    Then  a non empty cart should be created in the store account of the user

  Scenario: A customer is redirected to a report page after his cart is forwarded
    Given the "www.dummy-store.com" store
    And   I am logged in
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    And   I wait for the transfer to end
    Then  I should see "Votre panier a été transféré à 'www.dummy-store.com'"
    And   I should see a link "Aller vous connecter sur www.dummy-store.com pour payer" to "http://www.dummy-store.com/sponsored"

  Scenario: A customer is automaticaly unloged from the store after his cart is forwarded
    Given the "www.dummy-store.com" store
    And   I am logged in
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    And   I wait for the transfer to end
    Then  there should be an iframe with id "remote-store-iframe" and url "http://www.dummy-store.com/logout"

  Scenario: Failure due to invalid login-password
    Given the "www.dummy-store.com" store
    And   I am logged in
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
    And   I am logged in
    And   there are "PdT Charlottes" in the cart
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    And   I wait for the transfer to end
    Then  I should see "Nous n'avons pas pu ajouter 'PdT Charlottes' à votre panier sur 'www.dummy-store.com' parce que cela n'y est plus disponible"

  Scenario: The customer sees a work in progress page during the cart transfer
    Given the "www.dummy-store.com" store
    And   I am logged in
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    Then  I should see "Votre panier est en cours de transfert vers 'www.dummy-store.com'"
    And   the page should auto refresh
