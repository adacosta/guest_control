require "jennifer"
require "jennifer/adapter/postgres"
require "colorize"

# Jennifer::Config.read("config/database.yml", Amber.env.to_s)

if ENV.has_key?("DATABASE_URL")
  Jennifer::Config.from_uri(ENV["DATABASE_URL"])
else
  Jennifer::Config.configure do |conf|
    if ENV["DATABASE_HOST"]
      conf.host = ENV["DATABASE_HOST"]
    end
    if ENV["DATABASE_USER"]
      conf.user = ENV["DATABASE_USER"]
    end
    if ENV["DATABASE_PASSWORD"]
      conf.password = ENV["DATABASE_PASSWORD"]
    end
    conf.adapter = "postgres"
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
  end
end

Jennifer::Config.configure do |conf|
  Amber.logger.info("Amber.env = #{Amber.env}")
  conf.migration_files_path = "db/migrations"

  conf.logger = Logger.new(STDOUT)

  conf.logger.formatter = Logger::Formatter.new do |severity, datetime, progname, message, io|
    io << datetime.colorize(:cyan) << ": \n" << message.colorize(:light_magenta)
  end
  conf.logger.level = Logger::DEBUG
end
