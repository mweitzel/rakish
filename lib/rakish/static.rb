
module Rakish
  Static = Class.new do
    def initialize
      @kv_static = {}
    end

    def register(k, v)
      case k
      when :app
        def_normal(k, v, rakish_access: false)
      when :config
        def_normal(k, v, rakish_access: false)
      else
        def_normal(k, v)
      end
    end

    private

    def def_normal(k, v, rakish_access: true)
      @kv_static[k] = v
      self.class.define_method(k) { @kv_static[k] }

      if rakish_access
        selv = self
        Rakish.define_singleton_method(k) { selv.send(k) }
      end
    end
  end.new
end
