module HerokuCLI
  # Maintenance status of app
  class Maintenance < Base
    # display the current maintenance status of app
    def status
      heroku('maintenance').strip
    end

    # take the app out of maintenance mode
    def off
      heroku 'maintenance:off'
    end

    # put the app into maintenance mode
    def on
      heroku 'maintenance:on'
    end
  end
end
