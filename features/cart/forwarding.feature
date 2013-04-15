Feature: Cart Forwarding

  In order to have a smooth transfer experience to the real store
  A customer
  Wants to the forward operation to be explicit and straightforward

  Scenario: The customer sees a work in progress page during the cart transfer
    Given the "www.dummy-store.com" store
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    Then  I should see "Votre panier est en cours de transfert vers 'www.dummy-store.com'"
    And   the page should auto refresh

  Scenario: A customer is automaticaly unloged from the store after his cart is forwarded
    Given the "www.dummy-store.com" store
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    And   I wait for the transfer to end
    Then  there should be an iframe with id "remote-store-iframe" and url "http://www.dummy-store.com/logout"

  Scenario: A customer is redirected to a report page after his cart is forwarded
    Given the "www.dummy-store.com" store
    And   I am on the cart page
    And   I entered valid store account identifiers
    When  I press "Transférer le panier"
    And   I wait for the transfer to end
    Then  I should see "Votre panier a été transféré à 'www.dummy-store.com'"
    And   I should see a link "Aller vous connecter sur www.dummy-store.com pour payer" to "http://www.dummy-store.com/sponsored"

  @wip
  Scenario: A customer is accompanied through a transfer

    The transfer remains a long, tricky and unfamiliar process.
    It is important to be clear about what is happening and
    to make sure it is as straightforward as possible.

    Given I am transfering my cart to a store

    # When no items have yet been transfered
    # Then I should see that the transfer is starting

    When items are being transfered
    Then I should see that the transfer is ongoing

    When all items have been transfered
    Then I should see that it is logging out from the store

    # When the transfer is finished
    Then I should see a button to log into the store
