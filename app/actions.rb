# Homepage (Root path)
get '/' do
  erb :index
end

get '/users' do
  @users = User.all
  erb :'users/index'
end

get '/users/new' do
  erb :'users/register'
end

post '/users' do
  @user.create
end

get '/users/:id' do
  @user = User.find(params[:id])
  erb :'users/details'
end

get '/users/:id/edit' do
  @user = User.find(params[:id])
  erb :'users/edit'
end

put 'users/:id' do
  @user = User.find(params[:id])
  @user.first_name = params[:first_name]
  @user.last_name = params[:last_name]
  @user.email = params[:email]
  @user.password = params[:password]
  @user.save
  redirect "/users/params[:id]"
end

delete 'users/:id' do
  @user = User.find(params[:id])
  @user.destroy
  redirect "/users"
end

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

