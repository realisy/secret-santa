
get '/users' do
  @message = session[:message]
  session.delete(:message)
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
  # #
  @user.save
  session[:user_id] = @user.id
  redirect '/events'
end

get '/users/:id' do
  @message = session[:message]
  session.delete(:message)
  @user = User.find(params[:id])
  erb :'users/details'
end

get '/users/:id/edit' do
  @message = session[:message]
  session.delete(:message)
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
