get '/login' do
  @message = session[:message]
  session.delete(:message)
  erb :'users/login'
end

post '/login' do
  email = params[:email]
  password = params[:password]
  # We're using has_secure_password on User, so we'll check the password using
  # User#authenticate. Now, because we can get a wrong email too, we can have
  # a situation where User.find_by(email ...) will return nil, blowing up
  # on authenticate. To avoid that we'll use the .try() method, which
  # automatically stops if we get a nil from User#find_by.
  user = User.find_by(email: email).try(:authenticate, password)
  if user
    session.delete(:login_error) # Login successful, delete login error message
    session[:user_id] = user.id
    redirect '/events'
  else
    session.delete(:user_id) # Just to make sure we're logged out
    session[:message] = "Incorrect Username or password!"
    redirect '/login'
  end
end

get '/logout' do
  session.delete(:user_id)
  redirect '/'
end

