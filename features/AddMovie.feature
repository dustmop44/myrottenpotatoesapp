Feature: User can manually add movie
  
Background: 
  Given I am on the RottenPotatoes home page
  When I follow "Add new movie"
  Then I should be on the Create New Movie page
  
Scenario: Add a movie correctly
  When I fill in "Title" with "Men In Black"
  And I select "PG-13" from "Rating"
  And I press "Save Changes"
  Then I should be on the movie page for "Men In Black"
  And I should see "Men In Black"
  When I delete the movie: "Men In Black"
  Then I should be on the RottenPotatoes home page
  And I should see "Movie Men In Black deleted"
  And I should not see "More about Men In Black"

Scenario: Add a movie without title
  When I select "PG-13" from "Rating"
  And I press "Save Changes"
  Then I should be on the Movies page
  And I should see "Title can't be blank"
