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

# TODO blog place
