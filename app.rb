require "sinatra"
require "active_record"
require "rack-flash"
require "./lib/database_connection"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash


  def initialize
    super
    @database_connection = DatabaseConnection.new(ENV["RACK_ENV"])
  end

  get "/" do
    erb :root
  end

  get "/register" do
    erb :register
  end

  get "/login" do
    @user = @database_connection.find(session[:user_id])[:username]
    erb :login, :locals => {:user => @user}
  end

  post "/login" do
    user = find_user
    redirect "/error" if user == nil

    session[:user_id] = user[:id]
    redirect "/login"
  end

  post "/register" do
    flash[:notice] = "Thank you for registering"
    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}','#{params[:password]}')")
    redirect "/"
  end

  post "/" do

      session.sql(:user_id)
      redirect "/"
  end

  def find_user
      @database_connection.all.select { |x| x[:username] == params[:username] && x[:password] == params[:password] }[0]
  end


end
