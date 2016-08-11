def check_login
  @user = User.find_by(id: session[:user_id])
  unless @user
    session[:login_error] = "You must be logged in"
    redirect '/login'
  end
end

# Homepage (Root path)
get '/' do
  # binding.pry
  erb :index
end

get '/login' do
  @message = session[:message]
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



get '/users' do
  @users = User.all
  erb :'users/index'
end

post '/users' do
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

# delete 'users/:id' do
#   @user = User.find(params[:id])
#   @user.destroy
#   redirect "/users"
# end

#----------------------------------

get '/events' do
  @event = Event.all
  # Instead of all events, only the ones the user has access
  # (publics and the ones he is already enrolled)
  erb :'events/index'
end

get '/events/new' do
  erb :'events/new'
end

post '/events' do
  # We need to read the current user
  #  
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
  @event.save
  redirect '/events'
end

get '/events/:id' do
  @event = Events.find(params[:id])
  erb :'events/details'
end

get '/events/:id/edit' do
  @event = Events.find(params[:id])
  erb :'events/edit'
end

put 'events/:id' do
  @event = Events.find(params[:id])
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
  @event.save
  redirect "/events/params[:id]"
end

delete 'events/:id' do
  @event = Events.find(params[:id])
  @event.destroy
  redirect '/events'
end

#---------------------------------

get '/gifts' do
  @gift = Gift.all
  # TODO: Define what should be seen by user
  erb :'gifts/index'
end

get '/gifts/new' do
  erb :'gifts/new'
end

post '/gifts' do
  @gift = Gift.new
  @gift.gift_name = params[:gift_name]
  @gift.gift_description = params[:gift_description]
  @gift.est_values = params[:est_values]
  # TODO: ADD THE CURRENT USER
  @gift.save
  redirect '/gifts'
end

get '/gifts/:id' do
  @gift = Gift.find(id)
  erb :'gifts/details'
end

get '/gifts/:id/edit' do
  @gift = Gift.find(id)
  erb :'gifts/edit'
end

put 'gifts/:id' do
  @gift = Gift.find(id)
  @gift.gift_name = params[:gift_name]
  @gift.gift_description = params[:gift_description]
  @gift.est_values = params[:est_values]
  # TODO: ADD THE CURRENT USER
  @gift.save
  redirect "/gifts/params[:id]"
end

delete 'gifts/:id' do
  @gift = Gift.find(id)
  @gift.destroy
  redirect '/gifts'
end

