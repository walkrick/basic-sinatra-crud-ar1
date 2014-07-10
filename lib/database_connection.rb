require "yaml"
require "active_record"

class DatabaseConnection
  attr_reader :config, :connection

  def self.establish(environment)
    @@_connection ||= new(environment)
  end

  def initialize(environment = "development")
    @config = YAML.load(File.read("config/database.yml"))[environment]
    @connection = establish_connection
  end

  def sql(sql_string)
    connection.execute(sql_string).to_a
  end

  private_class_method :new
  private

  def establish_connection
    ActiveRecord::Base.establish_connection(
      :adapter  => config['adapter'],
      :database => config['database'],
      :username => config['username'],
      :password => config['password']
    ).connection
  end
end
