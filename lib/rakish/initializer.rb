module Rakish
  require 'logger'
  require 'singleton'

  class Global
    include Singleton

    def _exec(...)
      instance_exec(...)
    end
  end
  G = Global.instance

  module Initializer
    module_function

    # use module space as a pseudo-main

    def register(key, value)
      Global.instance._exec(key, value) do |kkey, vvalue|
        define_singleton_method(kkey) { vvalue }
      end
    end

    # register(:app, ::Application.new)
    register(:logger, Logger.new($stdout))

    Global.instance.logger.info('initializers, ok!')
  end
end
