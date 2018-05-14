module HerokuCLI
  class Application
    attr_reader :name

    def initialize(name)
      @name = name
    end

    def addons
      []
    end

    def features
      []
    end

    def maintenance
      @maintenance ||= Maintenance.new(self)
    end

    def pg
      @pg ||= PG.new(self)
    end
  end
end
