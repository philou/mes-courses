Feature: Cart Forwarding

  In order to have a smooth transfer experience to the real store
  A customer
  Wants to the forward operation to be explicit and straightforward

  Scenario: A customer is accompanied through a transfer

    The transfer remains a long, tricky and unfamiliar process.
    It is important to be clear about what is happening and
    to make sure it is as straightforward as possible.

    Given the "www.dummy-store.com" store
    When I start to transfer my cart to the store

    When no items have yet been transfered
    Then between 1% and 10% of the cart should have been transfered to "www.dummy-store.com"

    When items are being transfered
    Then between 10% and 90% of the cart should have been transfered to "www.dummy-store.com"

    When all items have been transfered
    Then the client should be automaticaly logged out from "www.dummy-store.com"

    # When the transfer is finished
    Then there should be a button to log into "www.dummy-store.com"
