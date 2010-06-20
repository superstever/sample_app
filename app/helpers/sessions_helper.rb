module SessionsHelper
  
  def sign_in(user)
    user.remember_me!
    cookies[:remember_token] = { :value => user.remember_token, 
                                  :expires => 20.years.from_now.utc }
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  def current_user
    @current_user ||= user_from_remember_token
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def user_from_remember_token
    remember_token = cookies[:remember_token]
    User.find_by_remember_token(remember_token) unless remember_token.nil?
  end
  
  def signed_in?
    !current_user.nil?
  end
  
  def sign_out
    cookies.delete(:remember_token)
    self.current_user = nil
  end
  
  def deny_access
    store_location
    flash[:notice] = "Please sign in to access this page."
    redirect_to signin_path
  end
  #the deny_acceess redirect_to signin_path is what makes the user_controlelr_spec tests for authentication edit/update pass

  def store_location
    session[:return_to] = request.request_uri
    #store_location puts url under session variable under the key :return_to. 
    #note the bracket session[:return_to] is a hash definition.
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def clear_return_to
    session[:return_to] = nil
  end
end
