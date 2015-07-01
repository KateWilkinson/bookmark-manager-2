require 'sinatra/base'

class BManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'

  set :views, proc { File.join(root, '..', 'view') }

  get '/' do
    user = User.first(session[:user_id])
    @user_email = user.email
    erb :index
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    link = Link.new(url: params[:url], title: params[:title]) unless params[:url] == "" || params[:title] == ""
    params[:tag].split.each do |input|
      link.tags << Tag.create(name: input)
    end
    link.save
    redirect '/links'
  end

  get '/links/new' do
    erb :'links/new_links'
  end

  get '/tags/:name' do
    tag = Tag.first(name: params[:name])
    @links = tag ? tag.links : []
    erb :'links/index'
  end

  get '/users/new' do
    erb :'links/new_user'
  end

  post '/users' do
    user = User.create(email: params[:email],
                password: params[:password])
    session[:user_id] = user.id
    redirect '/'
  end

  run! if app_file == $0
end
