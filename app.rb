
# http://localhost:4567/movies
# written by Veronika Kadesh

require 'sinatra'
require './lib/movie'
require './lib/movie_store'

store = MovieStore.new('movies.yml')

get('/movies') do
  @movies = store.all
  erb :index
end

get('/movies/new') do
  erb :new
end

# new begin

post('/movies/create') do
  @movie = Movie.new
  @movie.title = params['title']
  @movie.director = params['director']
  @movie.year = params['year']
  store.save(@movie)
  redirect '/movies'
end

get('/movies/:id/edit') do
  id = params['id'].to_i
  @movie = store.find(id)
  erb :edit
end

patch('/movies/:id/update') do
  id = params['id'].to_i
  @movie = store.find(id)
  @movie.title = params['title']
  @movie.director = params['director']
  @movie.year = params['year']
  store.save(@movie)
  redirect "/movies/#{id}"
end

delete('/movies/:id/destroy') do
  id = params['id'].to_i
  store.destroy(id)
  redirect to '/movies'
end

# new end

get('/movies/:id') do
  id = params['id'].to_i
  @movie = store.find(id)
  erb :show
end