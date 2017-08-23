Rails.application.routes.draw do

  resources :urls
  root 'urls#new'

end
