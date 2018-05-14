module HerokuCLI
  class Application
    attr_reader :name

    def initialize(name)
      @name = name
    end

    # tools and services for developing, extending, and operating your app
    def addons
      []
    end

    # disables an app feature
    def features
      []
    end

    # display the current maintenance status of app
    def maintenance
      @maintenance ||= Maintenance.new(self)
    end

    # manage postgresql databases
    def pg
      @pg ||= PG.new(self)
    end

    def ps
      @ps ||= ProcessStatus.new(self)
    end
  end
end
