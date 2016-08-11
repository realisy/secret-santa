# Homepage (Root path)
get '/' do
  binding.pry
  erb :index
end

get '/register' do
  erb :'register'
end

post '/register' do
  
end

get ''

# - Index Route;
# - Users Routes: New, Login, Details;
# - Events Routes: New, Enroll, Delete, Edit;
# - Gifts Route: Add, Edit, Delete;
