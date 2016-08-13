def check_login
  @user = User.find_by(id: session[:user_id])
  unless @user
    session[:message] = "You must be logged in"
    redirect '/login'
  end
end

# Homepage (Root path)
get '/' do
  if session[:user_id]
    redirect '/events'
  else
    @cities = City.all
    erb :index
  end
end

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

get '/users' do
  check_login
  @users = User.all
  erb :'users/index'
end

post '/users' do
  check_login
  @city = City.find_by_city_name(params[:city_name]) || City.new
  @city.city_name = params[:city_name]
  @city.province = params[:province]
  @city.country = params[:country]
  @city.save
  @user = User.new
  @user.first_name = params[:first_name]
  @user.last_name = params[:last_name]
  @user.email = params[:email]
  @user.password = params[:password]
  @user.city = @city
  @user.save
  redirect '/events'
end

get '/users/:id' do
  @user = User.find(params[:id])
  erb :'users/details'
end

get '/users/:id/edit' do
  @user = User.find(params[:id])
  erb :'users/edit'
end

put '/users/:id' do
  @user = User.find(params[:id])
  @user.first_name = params[:first_name]
  @user.last_name = params[:last_name]
  @user.email = params[:email]
  @user.password = params[:password] unless params[:password].nil?
  @user.save
  redirect "/users"
end

get '/events' do
  check_login
  # binding.pry
  @events = Event.where('public_event = ? OR user_id = ?', true, @user.id)
  # Instead of all events, only the ones the user has access
  # (publics and the ones he is already enrolled, or has been invited to)
  erb :'events/index'
end

get '/events/new' do
  check_login
  @event = Event.new
  erb :'events/new'
end

post '/events' do
  check_login
  @event = Event.new
  @event.event_name = params[:event_name]
  @event.event_description = params[:event_description]
  @event.start_date = params[:start_date]
  @event.registration_deadline = params[:registration_deadline]
  @event.event_date = params[:event_date]
  @event.public = params[:public]
  @event.max_participants = params[:max_participants]
  @event.min_value = params[:min_value]
  @event.max_value = params[:max_value]
  # TODO: Add current user and city to event
  @event.user = @user
  @event.city = @user.city
  @event.save
  redirect '/events'
end

get '/events/:id' do
  check_login
  @event = Event.find(params[:id])
  erb :'events/details'
end

get '/events/:id/edit' do
  check_login
  @event = Event.find_by(id: params[:id], user: @user)
  if @event.nil?
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    erb :'events/edit'
  end
end

put '/events/:id' do
  check_login
  @event = Event.find_by(id: params[:id], user: @user)
  if @event.nil?  
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    @event = Event.find(params[:id])
    @event.event_name = params[:event_name]
    @event.event_description = params[:event_description]
    @event.start_date = params[:start_date]
    @event.registration_deadline = params[:registration_deadline]
    @event.event_date = params[:event_date]
    @event.public = params[:public]
    @event.max_participants = params[:max_participants]
    @event.min_value = params[:min_value]
    @event.max_value = params[:max_value]
    @event.user = @user
    @event.city = @user.city
    @event.save
    redirect "/events/#{params[:id]}"
  end
end

delete '/events/:id' do
  check_login
  @event = Event.find_by(id: params[:id], user: @user)
  if @event.nil?  
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    @event.destroy
    redirect '/events'
  end
end

#---------------------------------

get '/users/:user_id/gifts' do
  check_login
  @gifted_user = User.find(params[:user_id])
  @gifts = Gift.where(user: @gifted_user)
  erb :'gifts/index'
end

get '/users/:user_id/gifts/new' do
  check_login
  @gift = Gift.new
  erb :'gifts/new'
end

post '/users/:user_id/gifts' do
  check_login
  @gift = Gift.new
  @gift.gift_name = params[:gift_name]
  @gift.gift_description = params[:gift_description]
  @gift.est_value = params[:est_value]
  @gift.user = @user
  @gift.save
  redirect "/users/#{params[:user_id]}/gifts/"
end

get '/users/:user_id/gifts/:id' do
  check_login
  @gift = Gift.find(params[:id])
  if @gift
    erb :'gifts/details'
  else
    session[:message] = "Gift not found"
    redirect "/users/#{params[:user_id]}/gifts/"
  end
end

get '/users/:user_id/gifts/:id/edit' do
  check_login
  @gift = Gift.find_by(id: params[:id], user: @user)
  if @gift
    erb :'gifts/edit'
  else
    session[:message] = "Gift not found"
    redirect "/users/#{params[:user_id]}/gifts/"
  end
end

put '/users/:user_id/gifts/:id' do
  check_login
  @gift = Gift.find_by(id: params[:id], user: @user)
  if @gift
    @gift.gift_name = params[:gift_name]
    @gift.gift_description = params[:gift_description]
    @gift.est_value = params[:est_value]
    @gift.save
    redirect "/users/#{params[:user_id]}/gifts/#{params[:id]}"
  else
    session[:message] = "Gift not found"
    redirect "/users/#{params[:user_id]}/gifts/"
  end
end

delete '/users/:user_id/gifts/:id' do
  check_login
  @gift = Gift.find_by(id: params[:id], user: @user)
  if @gift
    @gift.destroy
  else 
    session[:message] = "Gift not found"
  end
  redirect "/users/#{params[:user_id]}/gifts/"
end

