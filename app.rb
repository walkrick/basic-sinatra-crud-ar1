require "sinatra"
require "active_record"
require "rack-flash"
require "./lib/database_connection"

class App < Sinatra::Application
  enable :sessions
  use Rack::Flash


  def initialize
    super
    @database_connection = DatabaseConnection.establish(ENV["RACK_ENV"])
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


  # if (params[:username] || params[:password]) == ""
  # flash[:error] = "Please fill in all fields."
  # redirect "/"
  # end


  post "/login" do

    if params[:username] == "" && params[:password] == ""
    flash[:error] = "Username and password required."
    redirect "/"

    elsif params[:username] == ""
    flash[:error] = "Username required."
    redirect "/"

    elsif params[:password] == ""
    flash[:error] = "Password required."
    redirect "/"

    end

    user = @database_connection.sql("select * from users where username = '#{params[:username]}' and password = '#{params[:password]}'").first
    session[:user_id] = user["id"]
    redirect "/login"


  end

  post "/register" do

    if (params[:username] || params[:password]) == ""
      flash[:error] = "Please fill in all fields."
      redirect "/register"
    elsif  @database_connection.sql("SELECT * FROM users WHERE username = '#{params[:username].downcase}'") != []
      flash[:error] = "Username is already taken."
      redirect "/register"
    end


    flash[:notice] = "Thank you for registering"
    @database_connection.sql("INSERT INTO users (username, password) VALUES ('#{params[:username]}','#{params[:password]}')")
    redirect "/"
  end


  private

  def find_user(params)
    @database_connection.all.select { |x| x[:username] == params[:username] && x[:password] == params[:password] }[0]
  end



end
