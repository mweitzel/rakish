require 'zeitwerk'
require 'concurrent'

module Rakish
  module Loader
    module_function

    def init(dir: 'lib')
      @loader = Zeitwerk::Loader.new
      @loader.push_dir(dir)
      @loader.enable_reloading # generic to do this with only some env?
      @loader.setup

      Bundler.require
      Initializer.register(:lock, Concurrent::ReentrantReadWriteLock.new)
    end

    def prep(**kwargs)
      kwargs.each do |key, value|
        Initializer.register(key, value)
      end
    end

    def reload
      @loader.reload
    end
  end
end
