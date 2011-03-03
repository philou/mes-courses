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

  Scenario: A customer is redirected to the store after his cart is forwarded
    Given the "www.dummy-store.fr" store with api
    And   I am on the cart page
    When  I forward the cart to the store account of a valid user
    Then  I should be redirected to the store website

