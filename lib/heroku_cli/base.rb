module HerokuCLI
  class Base
    attr_reader :application

    def initialize(application)
      @application = application
    end

    protected

    def heroku(cmd)
      system "heroku #{cmd} -a #{application}"
    end
  end
end
