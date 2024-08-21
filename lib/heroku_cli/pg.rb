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
          stdout[0] = "===#{stdout[0]}"
          Database.new(stdout, self)
        end
      end
    end

    def reload
      @info = nil
    end

    # create a follower database
    def create_follower(database, options = {})
      plan = options.delete(:plan) || database.plan
      heroku "addons:create heroku-postgresql:#{plan}", "--follow #{database.resource_name}"
    end

    # Remove the following of a database and put DB into write mode
    def un_follow(database, wait: false)
      raise "Not a following database #{database.name}" unless database.follower?

      heroku "pg:unfollow #{database.url_name}", "-c #{application.name}"
      wait_for_follow_fork_transformation(database) if wait
    end

    # sets DATABASE as your DATABASE_URL
    def promote(database, wait: false)
      raise "Database already main #{database.name}" if database.main?

      un_follow(database, wait: wait) if database.follower?
      heroku "pg:promote #{database.resource_name}"
    end

    def destroy(database)
      raise "Cannot destroy #{application.name} main database" if database.main?
      heroku "addons:destroy #{database.url_name}", "-c #{application.name}"
    end

    # Return the main database
    def main
      info.find(&:main?)
    end

    # Returns an array of allow forks databases
    def forks
      info.find_all(&:fork?)
    end

    # Returns an array of allow follower databases
    def followers
      info.find_all(&:follower?)
    end

    # blocks until database is available
    def wait
      heroku 'pg:wait'
    end

    def wait_for_follow_fork_transformation(database)
      while database.follower? do
        puts "...wait 10 seconds for DB to change from follower to fork"
        sleep 10
        database.reload
        puts database
      end
    end
  end
end
