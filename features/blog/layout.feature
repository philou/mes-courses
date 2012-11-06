Feature: Blog layout
  In order to get visitors
  As the webmaster
  I want the blog to be integrated with the rest of the app

  There are a few advantages to emmbed a blog engine inside the main app
    * shared templates and styles
    * user connection links are synchronized
    * the heroku / google analytics bug can be workaround

  Scenario: Place link to the main app

    Validates that the blog engine's routes are correctly mounted
    inside the main app's routes

    Given I am logged in
    When I go to the blog page
    Then the places bar should contain a link "Recettes" to the full dish catalog page
    And there should be a link to the write a new article

  Scenario: Place link to the blog

    The blog should be accessible from the main app

    When I go to the dishes page
    Then the places bar should contain a link "Blog" to the blog page

  Scenario: Main blog layout

    The blog layout should include a sidebar for navigation and
    useful links

    When I go to the blog page
    Then I should see the whole blog sidebar

  @ignore
  Scenario: An article layout

    There should be custom navigation widgets for each article

    Given there is a blog article "Comment cuisiner des champignons"
    When I go to the blog article "Comment cuisiner des champignons" page
    Then I should see the whole blog sidebar
    And I should see the social and navigation article footer
