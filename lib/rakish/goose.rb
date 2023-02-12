# zeitwerk loaded module to forward all calls to Global.instance
module Rakish
  module Goose
    module_function

    def method_missing(...)
      Global.instance.send(...)
    rescue StandardError
      super(...)
    end
  end
end
