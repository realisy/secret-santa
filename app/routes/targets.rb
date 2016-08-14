
get '/users/:user_id/targets' do
  check_login
  @events = Event.joins(:users).where("users.id = ?", @user.id)
  # binding.pry
  erb :'targets/index'
end
