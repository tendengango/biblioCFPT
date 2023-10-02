Rails.application.routes.draw do
  
  devise_for :admins , controllers: { sessions: 'admins/sessions' , registrations: 'admins/registrations'}
  devise_for :librarians, controllers: { sessions: 'librarians/sessions' , registrations: 'librarians/registrations'}
  devise_for :students, controllers: { sessions: 'students/sessions' , registrations: 'students/registrations'}
  resources :books
  resources :librarians
  resources :admins
 
  get 'home/index'
  resources :students
  resources :covers
  resources :transactions

  root "home#index"
  get '/search' => 'books#search', :as => 'search'
  get 'transactions/index'
  get 'transactions/show'
  get 'transactions/edit'
  get 'transactions/update'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
