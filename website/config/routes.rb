Rails.application.routes.draw do
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
