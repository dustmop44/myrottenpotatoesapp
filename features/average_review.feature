Feature: Movies have average reviews
  
  As a movie fan
  So that I can see the community's opinions on movies
  I want to be able to see an average of everyone's reviews on a movie
  
Scenario: See average reviews of movie on index page
  Given the movie "Inception" exists
  And it has 5 reviews
  And its average review score is 3.0
  When I am on the RottenPotatoes home page
  Then I should see "3.0/5.0" within "#movies"
  