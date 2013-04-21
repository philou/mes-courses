Feature: Catalog import

  In order to control that everything runs fine
  A webmaster
  Wants an automatic import report email

  Scenario: An import report email is sent after the import

    Imports are automaticaly and regularly ran in production.
    Each time, we want to be notified about the outcome of it.

    Given the store "www.dummy-store.com"
    When  the scheduled automatic imports are ran
    Then  an import report email should be sent to the maintainer
