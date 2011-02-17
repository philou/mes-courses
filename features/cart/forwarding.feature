Feature: Cart Forwarding

  In order to be delivered my items
  A customer
  Wants the cart to detail quantities and prices

  Scenario: An empty cart is forwarded to the store
    Given the "www.dummy-store.fr" store with api
    And   I am on the cart page
    # TODO: replace all Whens with a single "Forward to the store account of a valid user"
    When  I fill in "store[login]" with "valid.email@mailinator.org"
    And   I fill in "store[password]" with "valid_password"
    And   I press "Transférer le panier"
    Then  an empty cart should be created in the store account of the user

  # Scenario: A real cart is forwarded to the store

  # Scenario: A customer is redirected to the store after his cart is forwarded

