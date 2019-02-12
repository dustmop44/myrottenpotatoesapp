class Movie < ActiveRecord::Base
  
  def self.ratings_present
    @list_of_ratings = []
    Movie.all.each do |movie|
      if @list_of_ratings.include? movie.rating
        next
      else
        @list_of_ratings << movie.rating
      end
    end
    return @list_of_ratings.sort
  end
  
  def self.filter_by_rating(ratings, sort_by)
    if !ratings.empty? && !sort_by.nil?
      return Movie.order(sort_by).where(rating: ratings)
    elsif !ratings.empty? && sort_by.nil?
      return Movie.where(rating: ratings)
    else
      return Movie.all
    end
  end
  
  def self.check_param_ratings(param_ratings)
    if param_ratings.class == Array
      return param_ratings
    elsif !param_ratings.nil?
      return param_ratings.keys
    else
      return []
    end
  end
  
  def self.check_sessions(params_ratings, session_ratings)
    if params_ratings.empty?
      return session_ratings
    else
      return params_ratings
    end
  end
    
end