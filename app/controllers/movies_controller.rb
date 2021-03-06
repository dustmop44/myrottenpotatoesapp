class MoviesController < ApplicationController
    rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
    
    def index
      params[:ratings] = Movie.check_param_ratings(params[:ratings])
      if params[:ratings].empty? && session[:ratings].nil?
        flash.keep
        session[:ratings] = ['G', 'PG', 'PG-13', 'R', 'NC-17']
        redirect_to movies_path(:ratings => session[:ratings], :sort_by => params[:sort_by])
        return
      end
      params[:ratings] = Movie.check_sessions(params[:ratings], session[:ratings])
      session[:ratings] = params[:ratings]
      session[:sort_by] = (session[:sort_by] ? session[:sort_by] : :id)
      if params[:sort_by].nil?
        params[:sort_by] = session[:sort_by]
        flash.keep
        redirect_to movies_path(:ratings => params[:ratings], :sort_by => params[:sort_by])
        return
      else
        session[:sort_by] = params[:sort_by]
      end
      movies_with_filters
      #filter_by_rating(params[:ratings], params[:sort_by]).no_reviews
      @ratings = params[:ratings]
      @sort_by = (!params[:sort_by].nil? ? params[:sort_by].to_s : nil)
      @all_ratings = Movie.ratings_present
    end
    
    def movies_with_filters
      @movies = Movie.all
      if params[:threshold].nil?
        params[:threshold] = Hash.new
        if session[:threshold].nil?
          params[:threshold]["with_good_reviews"] = "1"
          session[:threshold] = Hash.new
          session[:threshold]["with_good_reviews"] = params[:threshold]["with_good_reviews"]
        else
          params[:threshold]["with_good_review"] = session[:threshold]["with_good_reviews"]
        end
      end
      @threshold = params[:threshold]["with_good_reviews"]
      @movies = @movies.with_good_reviews(params[:threshold]["with_good_reviews"])
      if params[:no_reviews].nil?
        if session[:no_reviews].nil?
          session[:no_reviews] = "1"
        end
        params[:no_reviews] = session[:no_reviews]
      end
      if params[:no_reviews] == "1"
        @movies = Movie.no_reviews(@movies)
        @no_reviews = "1"
      end
      session[:no_reviews] = params[:no_reviews]
      @movies = Movie.filter_by_rating(params[:ratings], params[:sort_by], @movies)
      #@movies = Movie.where(id: @movies.map(&:id))
      %w(for_kids).each do |filter|
        if params[filter].nil?
          if session[filter].nil?
            session[filter] = "0"
          end
          params[filter] = session[filter]
        end
        if params[filter] == "1"
          @movies = @movies.send(filter)
        end
        instance_variable_set("@#{filter}", params[filter])
        session[filter] = params[filter]
      end
    end
    
    def show
        id = params[:id]
        @movie = Movie.find(id)
        render(:partial => 'moviepop', :object => @movie) if request.xhr?
    end
    
    def new
        @movie = Movie.new
    end
    
    def create
        @movie = Movie.new(movie_params)
        if @movie.save
            flash[:notice] = "Entry for #{@movie.title} was successfully created."
            redirect_to @movie
        else
            render 'new'
        end
    end
    
    def edit
        @movie = Movie.find(params[:id])
    end
    
    def update
        @movie = Movie.find(params[:id])
        if @movie.update_attributes(movie_params)
            flash[:notice] = "#{@movie.title} was successfully updated."
            respond_to do |client_wants|
                client_wants.html { 
                    flash[:notice] = "#{@movie.title} has been successfully updated."
                    redirect_to movie_path(@movie)
                }
                client_wants.xml { render :xml => @movie.to_xml }
            end
        else
            render 'edit'
        end
        
    end
    
    def destroy
        @movie = Movie.find(params[:id])
        @movie.destroy
        flash[:notice] = "Movie #{@movie.title} deleted."
        redirect_to movies_path
    end
    
    def search_tmdb
      @movies = Movie.find_in_tmdb(params[:search_terms])
    end
    
    private
        def movie_params
            params.require(:movie).permit(:title, :rating, :release_date, :description)
        end
        
        def record_not_found
            flash[:notice] = "No such movie was found."
            redirect_to movies_path
        end
end