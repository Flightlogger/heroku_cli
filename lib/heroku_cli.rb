require "heroku_cli/version"
require "heroku_cli/application"
require "heroku_cli/base"
require "heroku_cli/maintenance"
require "heroku_cli/pg"

# Wrap the CLI to interact with Heroku
module HerokuCLI
  # attach to an application
  def self.application(name)
    Application.new(name)
  end
end
