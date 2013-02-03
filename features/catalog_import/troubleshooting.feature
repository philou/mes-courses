Feature: Catalog import

  In order to control that everything runs fine
  A webmaster
  Wants an automatic import report email

  @deprecated
  Scenario: An import report email is sent after the import
    Given the "www.dummy-store.com" store
    When  items from the store are imported
    Then  an email ~"Import" should be sent to the maintainer
