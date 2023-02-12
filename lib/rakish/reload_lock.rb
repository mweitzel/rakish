require 'net/http'

module Rakish
  class ReloadLock
    def initialize(app)
      # @wait_group = 0
      @app = app
    end

    def call(env)
      if G.lock.try_write_lock
        env['reload_mutex'] = 'acquired'
        Loader.reload
        G.lock.release_write_lock
      end
      G.lock.with_read_lock do
        @app.call(env)
      end
    end
  end
end
