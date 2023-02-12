require 'zeitwerk'
loader = Zeitwerk::Loader.for_gem
loader.push_dir(__dir__)
loader.setup

# Top level namespace for Gem.
module Rakish
  def self.init(**kwargs)
    Loader.init(**kwargs)
  end

  def self.prep(app:, config:, **kwargs)
    Loader.prep(app:, config:, **kwargs)
  end

  def self.application
    @application ||= Application.new(
      Global.instance.app,
      Global.instance.config
    )
  end
end
