Rails.application.routes.draw do
  post '/add_movie', to: 'movies#add_movie', as: 'add_movie'
  get '/search', to: 'movies#search_tmdb', as: 'search_tmdb'
  resources :movies
  root :to => redirect('/movies')
end
