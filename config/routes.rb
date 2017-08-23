Rails.application.routes.draw do

  resources :urls
  root 'urls#new'
  get ':shortened_url' => 'urls#show'

end
