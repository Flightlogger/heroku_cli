require "heroku_cli/version"
require "heroku_cli/base"
require "heroku_cli/pg"

module HerokuCLI
  def self.pg(application)
    @pg ||= PG.new(application)
  end
end
