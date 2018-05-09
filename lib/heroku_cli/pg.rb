require_relative 'pg/database'

module HerokuCLI
  class PG < Base
    def follow(database_name, options = {})
      plan = options.delete(:plan) || 'standard-0'
      heroku "addons:create heroku-postgresql:#{plan} --follow #{database_name}"
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

    def main
      info.find(&:main?)
    end

    def forks
      info.find_all(&:fork?)
    end
  end
end
