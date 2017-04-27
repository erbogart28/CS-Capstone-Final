Rails.application.routes.draw do
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
    root 'home#land'  #root = default landing page for website
    get 'student/studentdashboard'
    get 'faculty/facultydashboard'
    get 'admin/admindashboard'

    get 'users/new' 
    get 'sessions/new'   
    get  '/signup',  to: 'users#new'
    get    '/login',   to: 'sessions#new'
    post   '/login',   to: 'sessions#create'
    delete '/logout',  to: 'sessions#destroy'
    resources :users
end
