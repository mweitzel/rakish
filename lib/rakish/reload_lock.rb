require 'net/http'
module Rakish
  class ReloadLock
    def initialize(app)
      # @wait_group = 0
      @app = app
    end

    def call(env)
      attempt_lock do |have_lock|
        if have_lock
          env["reload_mutex"] = "acquired"
          Loader.reload
        end
        @app.call(env)
      end
    end

    def attempt_lock &block
      uri = URI "http://localhost:8988"
      ::Net::HTTP.start(uri.host, uri.port) do |http|
        request = ::Net::HTTP::Get.new(uri)
        # puts 'before'
        http.request(request) do |response|
          # puts 'during'
          # puts response.code
          have_lock = response.code.to_s == "200"

          return block.call(have_lock)
        end
      end
    end
  end
end
