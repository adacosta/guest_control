require "sidekiq/cli"
# require "./src/sample"
require "../config/application"

cli = Sidekiq::CLI.new
server = cli.configure do |config|
  # middleware would be added here
end

cli.run(server)