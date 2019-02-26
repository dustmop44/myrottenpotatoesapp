
When("I should see all of the movies with ratings PG, R") do
  visit path_to("the RottenPotatoes home page")
  page.has_css?("table#movies tr", :count=>5)
end

When("I should not see all of the movies with ratings PG{int}, G") do |int|
  visit path_to("the RottenPotatoes home page")
  steps %{
    Then I should not see "Aladdin" within "#movies"
    And I should not see "Chocolat" within "#movies"
  }
end


When("I uncheck all the ratings") do
  ["G", "PG", "PG-13", "R"].each do |rating|
    uncheck("ratings_#{rating}")
  end
end

Then("I should see all of the movies with ratings G, PG") do
  visit path_to("the RottenPotatoes home page")
  page.has_css?("table#movies tr", :count=>5)
end

Then("I should see all of the movies with ratings G, PG, PG{int}, R") do |int|
  visit path_to("the RottenPotatoes home page")
  page.has_css?("table#movies tr", :count=>10)
end





Given /the following movies exist/ do |movies_table|
  movies_table.hashes.each do |movie|
    # each returned element will be a hash whose key is the table header.
    # you should arrange to add that movie to the database here.
    Movie.create! movie
  end
end

Then /(.*) seed movies should exist/ do | n_seeds |
  Movie.count.should be n_seeds.to_i
end

# Make sure that one string (regexp) occurs before or after another one
#   on the same page

Then /I should see "(.*)" before "(.*)"/ do |e1, e2|
  #  ensure that that e1 occurs before e2.
  #  page.body is the entire content of the page as a string.
  visit path_to("the RottenPotatoes home page")
  if page.respond_to? :should
    page.text.should match(/#{e1}.*#{e2}/)
  else
    assert page.has_content?(/#{e1}.*#{e2}/)
  end
end

# Make it easier to express checking or unchecking several boxes at once
#  "When I uncheck the following ratings: PG, G, R"
#  "When I check the following ratings: G"

When /I (un)?check the following ratings: (.*)/ do |uncheck, rating_list|
  # HINT: use String#split to split up the rating_list, then
  #   iterate over the ratings and reuse the "When I check..." or
  #   "When I uncheck..." steps in lines 89-95 of web_steps.rb
  
  if uncheck
    a = rating_list.scan(/[\w\-]+/)
    a.each do |rating|
      uncheck("ratings_" + rating)
    end
  elsif uncheck.nil?
    a = rating_list.scan(/[\w\-]+/)
    a.each do |rating|
      check("ratings_" + rating)
    end
  end
end

Then /I should see all the movies/ do
  visit path_to("the RottenPotatoes home page")
  page.has_css?("table#movies tr", :count=>10)
end