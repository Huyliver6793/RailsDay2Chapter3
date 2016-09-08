Rails.application.routes.draw do


  get 'help' => 'static_page#help'
  get 'about' => 'static_page#about'
  get 'contact' => 'static_page#contact'
  get 'signup' =>  'users#new'
  root 'static_page#home'
  
end
