require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.push_dir(__dir__)
loader.setup

# Top level namespace for Gem.
module Rakish
  def self.init(**kwargs)
    Loader.init(**kwargs)
    Static.register(:lock, Concurrent::ReentrantReadWriteLock.new)
  end

  def self.prep(app:, config:, **kwargs)
    Static.register(:app, app)
    Static.register(:config, config)
    kwargs.each do |key, value|
      Static.register(key, value)
    end
  end

  def self.application
    @application ||= Application.new(
      Static.app,
      Static.config
    )
  end

  def self.app
    Static.app.call.new
  end

  def self.config
    @config ||= Static.config.new
  end

  def self.static
    Static
  end
end
