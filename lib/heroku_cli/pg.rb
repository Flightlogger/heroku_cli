require_relative 'pg/database'

module HerokuCLI
  # manage postgresql databases
  class PG < Base
    # show database information
    def info
      @info ||= begin
        heroku('pg:info').split("===").reject(&:empty?).map do |stdout|
          next if stdout.nil? || stdout.length.zero?
          stdout = stdout.split("\n")
          Database.new(stdout.shift.strip, stdout)
        end
      end
    end

    # create a follower database
    def create_follower(database, options = {})
      plan = options.delete(:plan) || database.plan
      heroku "addons:create heroku-postgresql:#{plan} --follow #{database.resource_name}"
    end

    # Remove the following of a database and put DB into write mode
    def un_follow(database)
      raise "Not a following database #{database.name}" unless database.fork?
      heroku "pg:unfollow #{database.url_name} -c #{application.name}"
    end

    # sets DATABASE as your DATABASE_URL
    def promote(database)
      raise "Databse already main #{database.name}" if database.main?
      un_follow(database) if database.fork?
      heroku "pg:promote #{database.resource_name}"
    end

    # Return the main database
    def main
      info.find(&:main?)
    end

    # Returns an array of allow follower databases
    def forks
      info.find_all(&:fork?)
    end

    # blocks until database is available
    def wait
      heroku 'pg:wait'
    end
  end
end
