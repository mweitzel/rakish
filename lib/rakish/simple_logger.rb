module Rakish
  class SimpleLogger
    def initialize(app)
      @app = app
    end

    def call(env)
      time_0 = Time.now
      @app.call(env)
    ensure
      time_1 = Time.now
      ms = ((time_1 - time_0) * 1000).to_i
      puts "served in #{ms}ms - #{env["REQUEST_METHOD"]} #{env["REQUEST_PATH"]}"
    end
  end
end
