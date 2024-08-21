module HerokuCLI
  class Base
    attr_reader :application

    def initialize(application)
      @application = application.is_a?(String) ? Application.new(application) : application
    end

    def heroku(cmd, args=nil)
      if !args || args.strip.empty?
        puts "heroku #{cmd} -a #{application.name}"
        %x{ heroku #{cmd} -a #{application.name} }
      else
        puts "heroku #{cmd} -a #{application.name} -- #{args}"
        %x{ heroku #{cmd} -a #{application.name} -- #{args} }
      end
    end
  end
end
