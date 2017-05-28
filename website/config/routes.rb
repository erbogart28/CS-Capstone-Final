Rails.application.routes.draw do
  resources :users, only: [:index]  do
  post :impersonate, on: :member
  post :stop_impersonating, on: :collection
end
  resources :browse_courses
  resources :course_deliveries
  resources :prereqs
  resources :course_frequencies
  resources :course_terms
  resources :courses
  resources :path_courses
  resources :degree_reqs
  resources :paths
  resources :degrees
  resources :completed_courses
  resources :users

    get 'tos/tos'
    get 'student/studentdashboard'
    get 'faculty/facultydashboard'
    get 'studentview', to: 'faculty#studentview'
    get 'admin/admindashboard'
    post '/pull', to: 'pull_courses#create' # :to => '...'
    get 'users/new' 
    root 'sessions#new'   
    get  '/signup',  to: 'users#new'
    get    '/login',   to: 'sessions#new'
    post   '/login',   to: 'sessions#create'
    delete '/logout',  to: 'sessions#destroy'

	get		'when_if', to: 'when_ifs#index'
	post    'when_if', to: 'when_ifs#run'
end
