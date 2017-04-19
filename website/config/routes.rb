Rails.application.routes.draw do
    root 'home#land'  #root = default landing page for website
    get 'student/studentdashboard'
end
