# This file is app/controllers/movies_controller.rb
class MoviesController < ApplicationController
  before_action :store_session
  def index
    # @movies = Movie.order("#{params[:sort_by]}")
    puts "Ola estou aqui::"
    @teste ||= session[:sort_by]
    puts session[:sort_by]
    params[:sort_by] = %w{title release_date}.include?(params[:sort_by])? params[:sort_by] : ""
    # puts "ola"+ ("#{params[:sort_by]}")
    @movies = Movie.order("#{params[:sort_by]}")
    @all_ratings = Movie.all_ratings
    if params[:ratings].blank?
      params[:ratings]= {"G"=>"1", "PG"=>"1", "PG-13"=>"1", "NC-17"=>"1", "R"=>"1"}
      # puts "teste"
      # puts params[:ratings][2]
    else
      # puts"aui"
      # puts params[:ratings].keys
      # @movies = SELECT * FROM movies WHERE (movies.rating IN  "#{params[:ratings]}")
      @movies = Movie.where(rating: params[:ratings].keys)
      # @movies= Movie.find_each(:rating => params[:ratings])
    end
    @ratings = params[:ratings]
  # puts "meu teste"
  # puts @ratings["G"]
      
    # @movies= Movie.where(rating: params[:rating])
  end

  def show
    id = params[:id]
    @movie = Movie.find(id)
  end

  def new
    @movie = Movie.new
  end

  def store_session
    session[:sort_by] ||= []
    session[:ratings] ||= []

    if (!(params[:sort_by].blank?)&& (session[:sort_by]!=params[:sort_by]))
      #se parametros nao for vazio e session for diferente de parametros, setar session para parametros
      session[:sort_by] = params[:sort_by]
    end

    if (!(params[:ratings].blank?)&& (session[:ratings]!=params[:ratings]))
      #se parametros nao for vazio e session for diferente de parametros, setar session para parametros
      session[:ratings] = params[:ratings]
    end


  end

  def create
    #@movie = Movie.create!(params[:movie]) #did not work on rails 5.
    @movie = Movie.create(movie_params)
    flash[:notice] = "#{@movie.title} was successfully created!"
    redirect_to movies_path
  end

  def movie_params
    params.require(:movie).permit(:title,:rating,:ratings,:description,:release_date)
  end

  def edit
    id = params[:id]
    @movie = Movie.find(id)
    #@movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    #@movie.update_attributes!(params[:movie])#did not work on rails 5.
    @movie.update(movie_params)
    flash[:notice] = "#{@movie.title} was successfully updated!"
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find params[:id]
    @movie.destroy
    flash[:notice] = "#{@movie.title} was deleted!"
    redirect_to movies_path
  end
end