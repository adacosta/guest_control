ENV["AMBER_ENV"] = "test"

require "spec"
require "micrate"
require "garnet_spec"

require "../config/application"

Spec.before_each do
  Jennifer::Adapter.adapter.begin_transaction
end

Spec.after_each do
  Jennifer::Adapter.adapter.rollback_transaction
end

# Micrate::DB.connection_url = ENV['DATABASE_TEST_URL']

# Automatically run migrations on the test database
# Micrate::Cli.run_up
# Disable Granite logs in tests
# Granite.settings.logger = Amber.settings.logger.dup
