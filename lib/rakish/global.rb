module Rakish
  require 'logger'
  require 'singleton'

  class Global
    include Singleton

    def _exec(...)
      instance_exec(...)
    end
  end
  Global.instance
end
