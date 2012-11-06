Feature: Blog usage
  In order to get visitors
  As the webmaster
  I want a blog engine to post articles

  Going through main features of the blog makes sure that it is
  correctly integrated.

  Scenario: Writing an article

    Validates basic integration of the blog inside our app.

    Given I am logged in
    When I post a new blog article "Mes-courses.fr c'est super"
    Then there should be a blog article "Mes-courses.fr c'est super"

  Scenario: Going to the blog

    This simple test validates that the blogit_config and blogit_authenticate NoMethodErrors
    do not occur again.

    Given there is a blog article "Comment faire ses courses facilement"
    And I am on the home page
    When I go to the blog page
    Then there should be a blog article "Comment faire ses courses facilement"

  Scenario: Deleting an article

    Checks that blogit javascript and stylesheets are available to the main app

    Given I am logged in
    And there is a blog article "Comment faire ses courses facilement"
    When I delete the blog article "Comment faire ses courses facilement"
    Then there should not be a blog article "Comment faire ses courses facilement"
