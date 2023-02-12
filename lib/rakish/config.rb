module Rakish
  class Config
    def middleware
      [
        SimpleLogger,
        ReloadLock
      ]
    end
  end
end
