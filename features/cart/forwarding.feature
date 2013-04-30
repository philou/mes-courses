Feature: Cart Forwarding

  In order to have a smooth transfer experience to the real store
  A customer
  Wants to the forward operation to be explicit and straightforward

  @wip
  Scenario: A customer is accompanied through a transfer

    The transfer remains a long, tricky and unfamiliar process.
    It is important to be clear about what is happening and
    to make sure it is as straightforward as possible.

    Given the "www.dummy-store.com" store
    When I start to transfer my cart to the store

    # When no items have yet been transfered
    # Then I should see that the transfer is starting

    When items are being transfered
    Then the transfer to "www.dummy-store.com" should be ongoing

    When all items have been transfered
    Then the client should be automaticaly logged out from "www.dummy-store.com"

    # When the transfer is finished
    Then there should be a button to log into "www.dummy-store.com"
