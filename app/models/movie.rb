class Movie < ApplicationRecord
  has_many :reviews
  before_save :capitalize_title
  def self.all_ratings
    return ['G', 'PG', 'PG-13', 'R', 'NC-17']
  end
  validates :title, :presence => true
  validates :release_date, :presence => true
  validate :released_1888_or_later
  validates :rating, :inclusion => {:in => Movie.all_ratings}, :unless => :grandfathered?
  
  def released_1888_or_later
    errors.add(:release_date, 'must be 1888 or later') if
      release_date && release_date < Date.parse('1 Jan 1888')
  end
  
  @@grandfathered_date = Date.parse('1 Nov 1968')
  def grandfathered?
    release_date && release_date >= @@grandfathered_date
  end
  
  scope :with_good_reviews, lambda { |threshold|
    Movie.joins(:reviews).group(:movie_id).
      having(['AVG(reviews.potatoes) >= ?', threshold.to_i])
  }
  
  scope :for_kids, lambda { Movie.where(rating: ['G', 'PG']) }
  
  scope :recently_reviewed, lambda { |n| Movie.joins(:reviews).where(['reviews.created_at >= ?', n.days.ago]).uniq }
  
  def self.no_reviews(movies)
    return movies + Movie.includes(:reviews).where(reviews: {movie_id: nil})
  end
  
  
  def self.ratings_present
    @list_of_ratings = []
    if Movie.all.empty?
      return ['G', 'PG', 'PG-13', 'R', 'NC-17']
    end
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
  
  def capitalize_title
    self.title = self.title.split(/\s+/).map(&:downcase).map(&:capitalize).join(' ')
  end
  
    
end