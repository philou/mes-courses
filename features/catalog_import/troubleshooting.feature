Feature: Catalog import

  In order to control that everything runs fine
  A webmaster
  Wants an automatic daily import report email

  Scenario: Sending item import statitics by email
    Given "Fruits & Légumes > Pommes de terre > PdT Charlottes" item
    When stats are updated
    Then an email with subject containing "Import report" should be sent to "philippe.bourgau@free.fr"
