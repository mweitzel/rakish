module Rakish
  class SimpleLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      time0 = Time.now
      @app.call(env)
    ensure
      time1 = Time.now
      ms = ((time1 - time0) * 1000).to_i
      puts "served in #{ms}ms - #{env['REQUEST_METHOD']} #{env['REQUEST_PATH']}"
    end
  end
end
