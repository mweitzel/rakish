require 'net/http'

module Rakish
  class ReloadLock
    def initialize(app)
      # @wait_group = 0
      @app = app
    end

    def call(env)
      if Static.lock.try_write_lock
        env['reload_mutex'] = 'acquired'
        Loader.reload
        Static.lock.release_write_lock
      end
      Static.lock.with_read_lock do
        @app.call(env)
      end
    end
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
