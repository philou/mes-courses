# Copyright (C) 2011, 2012 by Philippe Bourgau

Feature: Authenticating users when they connect

  In order to know who is using the site
  As a webmaster
  I want users to be able to authenticate

  Scenario: Users are redirected to the home page after login
    Given I am not logged in
    When I log in
    Then I should be on the dishes page

  Scenario: Users are redirected to the home page after logout
    Given I am logged in
    When I log out
    Then I should be on the dishes page
