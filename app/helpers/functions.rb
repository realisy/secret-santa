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
            u.id = ?
          ORDER BY e.public_event, e.event_date desc", true, user.id, user.id])
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