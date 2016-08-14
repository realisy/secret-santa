
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

