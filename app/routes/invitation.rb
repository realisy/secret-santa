
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
