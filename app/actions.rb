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

def configure_pony
  Pony.options = {
    :via => :smtp,
    :via_options => {
      :address              => 'smtp.gmail.com',
      :port                 => '587',
      :enable_starttls_auto => true,
      :user_name            => 'rudolph.the.helper',
      :password             => 'SantasHelper',
      :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
      :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
    }
  }

end

# Homepage (Root path)
get '/' do
  @message = session[:message]
  if session[:user_id]
    redirect '/events'
  else
    @cities = City.all
    erb :index
  end
end

get '/help' do
  erb :help
end

get '/contact' do
  erb :contact
end

post '/contact' do
  configure_pony
  name = params[:name]
  sender_email = params[:email]
  message = params[:message]
  logger.error params.inspect
  begin
    Pony.mail(
      :from => "#{name}<#{sender_email}>",
      :to => 'rudolph.the.helper@gmail.com',
      :subject =>"#{name} has contacted you",
      :body => "#{message}"
    )
    if session[:user_id]
      session[:message] = "Thank you for the comment!"
      redirect '/events'
    else
      session[:message] = "Thank you for the comment!"
      redirect '/'
    end
  rescue
    @exception = $!
    erb :boom
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
  @user.name = params[:name]
  @user.email = params[:email]
  @user.password = params[:password] unless params[:password].nil?
  @user.save
  redirect "/users"
end

get '/events' do
  @message = session[:message]
  check_login
  # binding.pry
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


# =========================================
# Invitation Routes
# =========================================

get '/events/:id/invite' do
  check_login
  @event = Event.where(id: params[:id], creator: @user).first
  if @event.nil?  
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    erb :'invitations/index'
  end
end

post  '/events/:id/invite' do
  check_login
  @event = Event.where(id: params[:id], creator: @user).first
  if @event.nil?  
    session[:message] = "Permission Denied"
    redirect '/login' # TODO: Define best route.
  else
    names = params[:invited_name]
    emails = params[:invited_email]
    names.each_index do |i|
      invitation_code = Digest::SHA256.hexdigest("#{names[i]}#{emails[i]}")
      invitation = Invitation.create!(name: names[i], email: emails[i], user: @user, event: @event, invitation_code: invitation_code)
      # configure_pony
      begin
        Pony.mail({
          # :from => "rudolph.the.helper@gmail.com",
          :to => "#{names[i]} <#{emails[i]}>",
          :subject =>"#{@user.name} invited you to his secret santa!",
          :html_body => "#{invitation.email_body}",
          :via_options => {
            :address              => 'smtp.gmail.com',
            :port                 => '587',
            :enable_starttls_auto => true,
            :user_name            => 'rudolph.the.helper',
            :password             => 'SantasHelper',
            :authentication       => :plain, # :plain, :login, :cram_md5, no auth by default
            :domain               => "localhost.localdomain" # the HELO domain provided by the client to the server
          }
        })
      rescue StandardError => e
        puts e.message
      end
    end
    redirect "/events/#{params[:id]}"
  end
end



get '/accept_invite/:invite_code' do
  # find the invitation
  @cities = City.all
  session[:invite_code] = params[:invite_code]
  @invited = Invitation.find_by(invitation_code: params[:invite_code])
  # render the form
  binding.pry
  erb :'invitations/accept_invite'
end

post '/accept_invite' do
  @invited = Invitation.find_by(invitation_code: session[:invite_code])
  @city = City.find(params[:city_id]) 
  @user = User.new
  @user.name = params[:name]
  @user.email = @invited.email
  @user.password = params[:password]
  @user.city = @city
  # binding.pry
  @user.save
  session[:user_id] = @user.id

  @event = @invited.event
  @event.users << @user

  @invited.destroy

  redirect '/events'
end
