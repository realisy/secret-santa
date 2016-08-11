# Homepage (Root path)
get '/' do
  binding.pry
  erb :index
end

get '/users' do
  @user = User.all
end

get '/users/new' do
  erb :'/users/register'
end

post '/users' do
  @user.create
end

get '/users/:id' do
  erb :'/users/params[:id]'
end

get '/users/:id/edit' do
  erb :'/users/edit'
end

put 'users/:id' do
  @user.update
end

delete 'users/:id' do
  @user.destroy
end

----------------------------------

get '/events' do
  @event = Event.all
end

get '/events/new' do
  erb :'/events/register'
end

post '/events' do
  @event.create
end

get '/events/:id' do
  erb :'/events/params[:id]'
end

get '/events/:id/edit'
  erb :'/events/edit'
end

put 'events/:id' do
  @event.update
end

delete 'events/:id' do
  @event.destroy
end

---------------------------------

get '/gifts' do
  @gift = Gift.all
end

get '/gifts/new' do
  erb :'/gifts/register'
end

post '/events' do
  @gift.create
end

get '/events/:id' do
  erb :'/gifts/params[:id]'
end

get '/events/:id/edit'
  erb :'/gifts/edit'
end

put 'events/:id' do
  @gift.update
end

delete 'events/:id' do
  @gift.destroy
end
# - Index Route;
# - Users Routes: New, Login, Details;
# - Events Routes: New, Enroll, Delete, Edit;
# - Gifts Route: Add, Edit, Delete;
