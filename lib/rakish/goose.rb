# zeitwerk loaded module to forward all calls to Global.instance
module Rakish
  module Goose
    extend self
    def method_missing(...)
      Global.instance.send(...)
    rescue
      super(...)
    end
  end
end
