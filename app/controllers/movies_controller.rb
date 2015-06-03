class MoviesController < ApplicationController
  
  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    session[:orderBy] ||= ''
    session[:ratings] ||= Hash.new
    
    if((session[:orderBy] != '' && params[:orderBy].nil?) || (session[:ratings] != {} && params[:ratings].nil?))
      params[:orderBy]   ||= session[:orderBy] 
      params[:ratings] ||= session[:ratings]
      redirect_to movies_path(params) and return
      
    end
    
    if !params[:orderBy].nil?
      session[:orderBy] = params[:orderBy]
    end
    if !params[:ratings].nil?
      session[:ratings] = params[:ratings]
    end
    
    @orderBy = params[:orderBy]
    @all_ratings = Movie.allRatings
    
    if params[:ratings] == nil
      @ratings = Hash[ @all_ratings.collect { |v| [v , '1'] } ]
    else
      @ratings = params[:ratings]
    end 
    
    if(!@ratings.nil?)
      @movies = Movie.where(:rating => @ratings.keys)
    end
    
    @movies = @movies.find(:all, :order => @orderBy)
    
  end
  
  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end
