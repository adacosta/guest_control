ENV["AMBER_ENV"] = "test"

require "spec"
require "micrate"
require "garnet_spec"

require "../config/application"

Micrate::DB.connection_url = ENV['DATABASE_TEST_URL']

# Automatically run migrations on the test database
Micrate::Cli.run_up
# Disable Granite logs in tests
Granite.settings.logger = Amber.settings.logger.dup
