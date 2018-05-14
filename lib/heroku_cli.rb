require "heroku_cli/version"
require "heroku_cli/application"
require "heroku_cli/base"
require "heroku_cli/maintenance"
require "heroku_cli/pg"

module HerokuCLI
  def self.application(name)
    Application.new(name)
  end
end
