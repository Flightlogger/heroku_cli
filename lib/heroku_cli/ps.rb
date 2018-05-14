module HerokuCLI
  # list dynos for an app
  class ProcessStatus < Base
    # restart app dynos
    def restart
      heroku 'ps:restart'
    end
  end
end
