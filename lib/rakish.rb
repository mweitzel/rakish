require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.push_dir(__dir__)
loader.setup

# Top level namespace for Gem.
module Rakish
  def self.init(**kwargs)
    Loader.init(**kwargs)
    G.register(:lock, Concurrent::ReentrantReadWriteLock.new)
  end

  def self.prep(app:, config:, **kwargs)
    G.register(:app, app)
    G.register(:config, config)
    kwargs.each do |key, value|
      G.register(key, value)
    end
  end

  def self.application
    @application ||= Application.new(
      G.app,
      G.config
    )
  end

  # namespace as pseudo main
  G = Class.new do
    def initialize
      @kv = {}
    end

    def register(k, v)
      @kv[k] = v
      self.class.define_method(k) { @kv[k] }
    end
  end.new
end
