class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    # first update the session hash
    # set higlight for columns according to where we come from
    if (params[:hilite1] || params[:hilite2])
      session[:hilite1] = params[:hilite1] # retrieve hilite status1
      session[:hilite2] = params[:hilite2] # retrieve hilite status2
    else  # coming from refresh
      # get which boxes were checked, if any
      session[:ratings] = []
      if (params[:ratings])
        session[:ratings] = params[:ratings].keys
      end
    end
    # now update instance variables to be used in the view
    # get the list of ratings to pass to the view, for filtering
    @all_ratings = Movie.all_ratings
    # the values of session to pass on the view
    @hilite1 = session[:hilite1]
    @hilite2 = session[:hilite2]
    @ratings = session[:ratings]
    # decide on the order to use for the movies (if any)
    if (@hilite1) 
      order_by = "title ASC"
    else
      order_by = "release_date ASC"
    end
    # get the movies, order by criteria above, and only for the ratings in session
    @movies = []
    if (@ratings)
      @movies = Movie.find(:all, :conditions => [ "rating IN (?)", @ratings], :order => order_by)
    end
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
