Rails.application.routes.draw do
  
  get 'errors/not_found'
  get 'errors/internal_server_error'
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
  get '/returnBook' => 'books#returnBook', :as => 'returnBook'
  get '/checkout' => 'books#checkout', :as => 'checkout'
  get '/books_students' => 'books#books_students', :as => 'books_students'
  get '/list_checkedoutBooksAndStudentsAdmin' => 'books#list_checkedoutBooksAndStudentsAdmin', :as => 'list_checkedoutBooksAndStudentsAdmin'
  get '/list_checkedoutBooks' => 'books#list_checkedoutBooks', :as => 'list_checkedoutBooks'
  get '/show_librarians' => 'admins#show_librarians', :as => 'show_librarians'
  get '/restricted' => 'librarians#restricted', :as => 'restricted'
  get '/show_students' => 'admins#show_students', :as => 'show_students'
  get '/show_books' => 'admins#show_books', :as => 'show_books'
  get '/add_books' => 'books#new', :as => 'add_books'
  get '/add_students' => 'students#new', :as => 'add_students'
  get '/add_librarians' => 'librarians#new', :as => 'add_librarians'
  get '/getBookmarkBooks' => 'books#getBookmarkBooks', :as => 'getBookmarkBooks'
  get '/librarian_book_view' => 'books#librarian_book_view', :as => 'librarian_book_view'
  get '/getStudentBookFine' => 'books#getStudentBookFine', :as => 'getStudentBookFine'
  get '/viewBookHistory' => 'books#viewBookHistory', :as => 'viewBookHistory'
  get '/getOverdueBooks' => 'books#getOverdueBooks', :as => 'getOverdueBooks'
  get 'transactions/index'
  get 'transactions/show'
  get 'transactions/edit'
  get 'transactions/update'
  
  match "/404", :to => "errors#not_found", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all
  
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
