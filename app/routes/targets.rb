
get '/users/:user_id/targets' do
  check_login
  @user_id = params[:user_id]
  @events = Event.joins(:users).where("users.id = ?", @user.id)
  # binding.pry
  erb :'targets/index'
end
