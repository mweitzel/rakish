module Rakish
  class Application
    attr_reader :config

    def initialize(app, config)
      config = config.new if config.is_a?(Class)
      @app = ReloadShim.new(app)
      @config = config
      @app_with_mw = @config.middleware.reverse.reduce(@app) do |app, mw|
        mw.new(app)
      end
    end

    def call(...)
      @app_with_mw.call(...)
    end

    class ReloadShim
      attr_accessor :app

      def initialize(klass_proc)
        @klass_proc = klass_proc
        reload
      end

      def call(env)
        reload if env['reload_mutex'] == 'acquired'
        @app.call(env)
      end

      def reload
        klass = @klass_proc.call
        @app = klass.new
      end
    end
  end
end
