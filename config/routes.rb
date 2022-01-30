Rails.application.routes.draw do
  resources :word_libraries, only: [:index, :edit, :update] 
  delete 'create_random_list', to: 'word_libraries#create_random_list'

  get 'word_libraries/scaffold'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "games#index"

  get 'guess', to: 'games#guess'

end
