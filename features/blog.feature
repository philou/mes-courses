Feature: Blog
  In order to get visitors
  As the webmaster
  I want a blog engine to post articles

  There are a few advantages to emmbed a blog engine inside the main app
    * shared templates and styles
    * user connection links are synchronized
    * the heroku / google analytics bug can be workaround

  Scenario: Links
    Given I am logged in
    When I go to the blog page
    Then the places bar should contain a link "Recettes" to the full dish catalog page
    And there should be a link to the write a new article

  Scenario: Writing an article
    Given I am logged in
    When I post a new blog article "My first great article" with content
      """
      Really interesting stuff ...
      """
    Then there should be a blog article "My first great article"

  Scenario: Going to the blog

    This simple test validates that the blogit_config and blogit_authenticate NoMethodErrors
    do not occur again.

    Given there is an article "Comment faire ses courses facilement" with content
       """
       Utilisez mes-courses.fr
       """
    And I am on the home page
    When I go to the blog page
    Then there should be a blog article "Comment faire ses courses facilement"

# TODO blog place
