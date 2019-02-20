class Review < ApplicationRecord
  belongs_to :user
  belongs_to :movie
  validates :movie_id, :presence => true
  validates_associated :movie
  
  def self.find_by_movie(movie)
    return Review.where(movie_id: movie.id)
  end
  
end
