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
    @user = @database_connection.sql("select username from users where id = #{session[:user_id]}").first
    erb :login, :locals => {:user => @user}
  end

  get "/logout" do
    redirect "/"
  end





  post "/login" do
    user = @database_connection.sql("select * from users where username = '#{params[:username]}' and password = '#{params[:password]}'").first
    session[:user_id] = user["id"]
    redirect "/login"
  end

  post "/register" do
    flash[:notice] = "Thank you for registering"
    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}','#{params[:password]}')")
    redirect "/"
  end


  private

  def find_user(params)
    @database_connection.all.select { |x| x[:username] == params[:username] && x[:password] == params[:password] }[0]
  end


end
