module HerokuCLI
  class Base
    attr_reader :application

    def initialize(application)
      @application = application.is_a?(String) ? Application.new(application) : application
    end

    protected

    def heroku(cmd)
      %x{ heroku #{cmd} -a #{application.name} }
    end
  end
end
