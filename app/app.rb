require 'sinatra/base'
require 'sinatra/flash'

class BManager < Sinatra::Base
  enable :sessions
  set :session_secret, 'super secret'
  register Sinatra::Flash

  set :views, proc { File.join(root, '..', 'view') }

  get '/' do
    erb :index
  end

  get '/links' do
    @links = Link.all
    erb :'links/index'
  end

  post '/links' do
    redirect '/links' if params[:url] == "" || params[:title] == ""
    link = Link.new(url: params[:url], title: params[:title])
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
    @user = User.new
    erb :'users/new_user'
  end

  post '/users' do
    @user = User.create(email: params[:email],
                       password: params[:password],
                       password_confirmation: params[:password_confirmation])
    if @user.save
      session[:user_id] = user.id
      redirect '/'
    else
      flash.now[:notice] = "Sorry, your passwords do not match"
      erb :'users/new_user'
    end
  end

  helpers do
    def current_user
      @id ||= session[:user_id]
      User.first(id: @id)
    end
  end
  run! if app_file == $0
end
