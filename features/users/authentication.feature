# Copyright (C) 2011 by Philippe Bourgau

Feature: Authenticating users when they connect

  In order to know who is using the site
  As a webmaster
  I want users first to authenticate

  Scenario: Users have to authenticate before going to the home page
    Given I am not logged in
    When I try to go to the home page
    Then I should be redirected to the login page

  Scenario: Once logged in, users should be redirected to where they wanted to go
    Given I am not logged in
    And I tried to go to the cart page
    When I log in
    Then I should be on the cart page
