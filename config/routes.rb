Rails.application.routes.draw do

  root 'static_page#home'
  get 'help' => 'static_page#help'
  get 'about' => 'static_page#about'
  get 'contact' => 'static_page#contact'
  get 'signup' =>  'users#new'
  resources :users
  
end
