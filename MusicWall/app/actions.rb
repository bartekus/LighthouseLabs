helpers do
  def user_logged_in?
    session[:email] && session[:email] != "" 
  end

  def get_current_user
    if user_logged_in?
      User.find_by_email(session[:email])
    end
  end
end

get '/' do
  redirect '/songs'
end

get '/songs' do
  @tracks = Track.all
  erb :"songs/index"
end

get '/login' do redirect '/user_session/new' end
get '/user_session/new' do
  erb :'user_session/new'
end

post '/user_session' do
  @user = User.find_by_email(params[:email])
  if @user && @user.password == params[:password]
    session[:email] = @user.email
    redirect '/'
  else
    erb :'user_session/new'  # sends back HTML. we can use the @user.email to keep the email populated in the user_session/new.erb form.
    # redirect '/user_session/new'  # asks the browser to make a brand new request for '/user_session/new'
  end
end

get '/logout' do
  session[:email] = ""
  redirect '/'
end

get '/users/new' do
  @user = User.new
  erb :'users/new'
end

post '/users' do
  @user = User.new(
    email:    params[:email],
    password: params[:password]
    )
  if @user.save
    session[:email] = @user.email
    redirect '/'
  else
    erb :'users/new'
  end
end

get '/songs/new' do
  erb :'songs/new'
end 

post '/songs' do
  @track = Track.new(
    title:    params[:title],
    author:   params[:author],
    url:      params[:url],
    user_id:  get_current_user.id
    )
  if @track.save
    redirect '/'
  else
    erb :'/songs/new'
  end
end

post '/songs/:song_id/votes' do
  if params[:type] == "upvote"
    vote_count = 1
  else
    vote_count = -1
  end

  Vote.create(
    user_id: get_current_user.id,
    song_id: params[:song_id],
    vote_count: vote_count
    )
  redirect '/'
end

