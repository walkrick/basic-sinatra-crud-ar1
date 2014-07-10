require "yaml"
require "active_record"

class DatabaseConnection
  attr_reader :connection

  def self.establish(environment = "development", config_file_path="config/database.yml")
    @@_connection ||= new(environment, config_file_path)
  end

  def self.clear!
    @@_connection = nil
  end

  def initialize(environment, config_file_path)
    begin
      file = File.read(config_file_path)
      config = YAML.load(file)[environment]
      @connection = establish_from_config(config)
    rescue Errno::ENOENT
      @connection = establish_from_uri(ENV["DATABASE_URL"])
    end
  end

  def sql(sql_string)
    connection.execute(sql_string).to_a
  end

  private_class_method :new
  private

  def establish_from_config(config)
    ActiveRecord::Base.establish_connection(
      :adapter => config['adapter'],
      :database => config['database'],
      :username => config['username'],
      :password => config['password']
    ).connection
  end

  def establish_from_uri(uri)
    ActiveRecord::Base.establish_connection(uri).connection
  end
end
