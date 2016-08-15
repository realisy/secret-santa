
get '/users/:user_id/gifts' do
  @message = session[:message]
  session.delete(:message)
  check_login
  @gifted_user = User.find(params[:user_id])
  @gifts = Gift.where(user: @gifted_user)
  erb :'gifts/index'
end

get '/users/:user_id/gifts/new' do
  @message = session[:message]
  session.delete(:message)
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
  @message = session[:message]
  session.delete(:message)
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
  @message = session[:message]
  session.delete(:message)
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
