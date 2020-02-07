require "jennifer"
require "jennifer/adapter/postgres"
require "colorize"

# Jennifer::Config.read("config/database.yml", Amber.env.to_s)

Jennifer::Config.configure do |conf|
  conf.migration_files_path = "db/migrations"
  conf.host = ENV["DATABASE_HOST"]
  conf.user = ENV["DATABASE_USER"]
  conf.password = ENV["DATABASE_PASSWORD"]
  conf.adapter = "postgres"
  Amber.logger.info("Amber.env = #{Amber.env}")
  case Amber.env.to_s
  when "development"
    conf.db = "guest_control_development"
  when "production"
    conf.db = "guest_control"
  when "test"
    conf.db = "guest_control_test"
  else
    Amber.logger.info("No database defined for env: '#{Amber.env}'")
  end

  conf.logger = Logger.new(STDOUT)

  conf.logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
    io << datetime.colorize(:cyan) << ": \n" << message.colorize(:light_magenta)
  end
  conf.logger.level = Logger::DEBUG
end