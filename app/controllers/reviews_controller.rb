class ReviewsController < ApplicationController
  before_action :has_moviegoer_and_movie, :only => [:new, :create]
  protected
  def has_moviegoer_and_movie
    unless current_user
      flash[:warning] = 'You must be logged in to create a review.'
      redirect_to new_user_registration_url
    end
    unless (@movie = Movie.find_by_id(params[:movie_id]))
      flash[:warning] = 'Review must be for an existing movie.'
      redirect_to movies_path
    end
  end
  
  public
  def new
    if @movie.id.in?(current_user.reviews.collect {|review| review.movie_id})
      @review = current_user.reviews.where(movie_id: @movie.id)
      flash[:notice] = "You have already reviewed this movie."
      redirect_to movie_path(@movie)
      return
    else
      @review = @movie.reviews.build
    end
  end
  
  def create
    current_user.reviews << @movie.reviews.build(review_params)
    redirect_to movie_path(@movie)
  end
  
  def edit
    @review = Review.find(params[:id])
    @movie = Movie.find(params[:movie_id])
  end
  
  def update
    @review = Review.find(params[:id])
    @movie = Movie.find(params[:movie_id])
    if @review.update_attributes(review_params)
        flash[:notice] = "Your review for #{@movie.title} was successfully updated."
        respond_to do |client_wants|
            client_wants.html { 
                flash[:notice] = "Your review for #{@movie.title} has been successfully updated."
                redirect_to movie_path(@movie)
            }
            client_wants.xml { render :xml => @movie.to_xml }
        end
    else
        render 'edit'
    end
  end
  
  def destroy
    @movie = Movie.find(params[:movie_id])
    @review = Review.find(params[:id])
    @review.destroy
    flash[:notice] = "Your review for movie #{@movie.title} deleted."
    redirect_to movie_path(@movie)
  end
  
  private
    def review_params
      params.require(:review).permit(:potatoes, :comments)
    end
    
end