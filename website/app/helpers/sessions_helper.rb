module SessionsHelper
    # Logs in the given user.
    def log_in(user)
        session[:user_id] = [user.id] 
    end
    # Remembers a user in a persistent session.
    def remember(user)
    user.remember
    cookies.permanent.signed[:user_id] = user.id
    cookies.permanent[:remember_token] = user.remember_token
    end
    
    # Returns true if the given user is the current user.
    def current_user?(user)
        user == current_user
    end
    
    # Returns the current logged-in user (if any).
    def current_user
        session.clear if session[:user_id].class == Fixnum
        @current_user ||= User.find_by(id: session[:user_id].last) if session[:user_id]
    end
    
    # Returns true if the user is logged in, false otherwise.
    def logged_in?
        !current_user.nil?
    end
        
    def log_out
        session[:user_id].pop()
        @current_user = nil
    end
    
    # Redirects to stored location (or to the default).
    def redirect_back_or(default)
    redirect_to(session[:forwarding_url] || default)
        session.delete(:forwarding_url)
    end
    
    # Stores the URL trying to be accessed.
    def store_location
        session[:forwarding_url] = request.original_url if request.get?
    end
    
   def index
    @users = User.order(:id)
    end
end
