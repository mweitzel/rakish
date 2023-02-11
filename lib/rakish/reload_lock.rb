require 'net/http'
module Rakish
  class ReloadLock
    def initialize(app)
      # @wait_group = 0
      @app = app
    end

    def call(env)
      if Rakish::Global.instance.lock.try_write_lock
        env["reload_mutex"] = "acquired"
        Loader.reload
        Rakish::Global.instance.lock.release_write_lock
      end
      Rakish::Global.instance.lock.with_read_lock do
        @app.call(env)
      end
    end

#   def attempt_lock &block
#     uri = URI "http://localhost:8988"
#     ::Net::HTTP.start(uri.host, uri.port) do |http|
#       request = ::Net::HTTP::Get.new(uri)
#       http.request(request) do |response|
#         have_lock = response.code.to_s == "200"

#         return block.call(have_lock)
#       end
#     end
#   end
  end
end
