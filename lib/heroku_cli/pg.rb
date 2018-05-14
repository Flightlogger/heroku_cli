require_relative 'pg/database'

module HerokuCLI
  class PG < Base
    def wait
      heroku 'pg:wait'
    end

    def info
      @info ||= begin
        heroku('pg:info').split("===").reject(&:empty?).map do |stdout|
          next if stdout.nil? || stdout.length.zero?
          stdout = stdout.split("\n")
          Database.new(stdout.shift.strip, stdout)
        end
      end
    end

    def create_follower(database, options = {})
      plan = options.delete(:plan) || database.plan
      heroku "addons:create heroku-postgresql:#{plan} --follow #{database.resource_name}"
    end

    def un_follow(database)
      raise "Not a following database #{database.name}" unless database.fork?
      heroku "pg:unfollow #{database.url_name} -c #{application.name}"
    end

    def main
      info.find(&:main?)
    end

    def forks
      info.find_all(&:fork?)
    end
  end
end
