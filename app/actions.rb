require_relative 'helpers/functions'
require_relative 'routes/users'
require_relative 'routes/events'
require_relative 'routes/gifts'
require_relative 'routes/invitation'
require_relative 'routes/login'
require_relative 'routes/contact'

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


