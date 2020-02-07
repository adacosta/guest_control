# require "granite/adapter/pg"
# # development/test only have the base url with database storing the db name
# db_url_parts = Amber.settings.database_url.split("/")
# db_url = db_url_parts[0..2].join('/')
# if Amber.env == "development"
#   db_url += "/guest_control_development"
# elsif Amber.env == "test"
#   db_url += "/guest_control_test"
# end
# Amber.logger.info("db_url = #{db_url}")
# Granite::Connections << Granite::Adapter::Pg.new(name: "pg", url: db_url)
# Granite.settings.logger = Amber.settings.logger.dup
# Granite.settings.logger.not_nil!.progname = "Granite"
