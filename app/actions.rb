def check_login
  @user = User.find_by(id: session[:user_id])
  unless @user
    session[:message] = "You must be logged in"
    redirect '/login'
  end
end

def find_events(user)
  Event.find_by_sql(
        ["SELECT DISTINCT e.* 
          FROM events e 
            LEFT OUTER JOIN events_users eu 
              ON e.id = eu.event_id  
            LEFT OUTER JOIN users u
              ON eu.user_id = u.id
          WHERE 
            e.public_event = ?  OR
            e.creator_id = ?       OR
            u.id = ?", true, user.id, user.id])
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
  @city = City.find(params[:city_id]) 
  @user = User.new
  @user.name = params[:name]
  @user.email = params[:email]
  @user.password = params[:password]
  @user.city = @city
  # binding.pry
  @user.save
  session[:user_id] = @user.id
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

  # Selects events that: 
  # Are public; OR
  # User has created; OR
  # User is enrolled
  # public_events = Event.where(public_event: true)
  # owned_events = Event.where(user: @user)
  # part_events = Event.joins(:users).where('events_users.user_id = ?', @user.id)
  # @events = (public_events + owned_events + part_events).uniq
  @events = find_events(@user)
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
  @event.public_event = params[:public_event]
  @event.max_participants = params[:max_participants]
  @event.min_value = params[:min_value]
  @event.max_value = params[:max_value]
  @event.creator = @user
  @event.city = @user.city
  @event.users << @event.creator ## ADDS The creator as a participant
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
  @event = Event.find_by(id: params[:id], creator: @user)
  if @event.nil?
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    erb :'events/edit'
  end
end

put '/events/:id' do
  check_login
  @event = Event.find_by(id: params[:id], creator: @user)
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
    @event.public_event = params[:public_event]
    @event.max_participants = params[:max_participants]
    @event.min_value = params[:min_value]
    @event.max_value = params[:max_value]
    @event.creator = @user
    @event.city = @user.city
    @event.save
    redirect "/events/#{params[:id]}"
  end
end

delete '/events/:id' do
  check_login
  @event = Event.where(id: params[:id], creator: @user)
  if @event.nil?  
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    @event.destroy
    redirect '/events'
  end
end


get '/events/:id/enroll' do
  check_login
  @events = find_events(@user).find(nil) {|event| event.id == params[:id].to_i}
    binding.pry
  if @events.nil?
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    @event = Event.find(params[:id])
    @event.users << @user
    @event.save
    redirect "/events/#{params[:id]}"
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
  redirect "/users/#{params[:user_id]}/gifts"
end

get '/users/:user_id/gifts/:id' do
  check_login
  @gift = Gift.find(params[:id])
  if @gift
    erb :'gifts/details'
  else
    session[:message] = "Gift not found"
    redirect "/users/#{params[:user_id]}/gifts"
  end
end

get '/users/:user_id/gifts/:id/edit' do
  check_login
  @gift = Gift.find_by(id: params[:id], user: @user)
  if @gift
    erb :'gifts/edit'
  else
    session[:message] = "Gift not found"
    redirect "/users/#{params[:user_id]}/gifts"
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
    redirect "/users/#{params[:user_id]}/gifts"
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
  redirect "/users/#{params[:user_id]}/gifts"
end


# =========================================
# TARGETS ROUTES 
# =========================================


get '/users/:user_id/targets' do
  check_login
  @events = Event.joins(:users).where("users.id = ?", @user.id)
  # binding.pry
  erb :'targets/index'
end
