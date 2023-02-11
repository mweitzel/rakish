
require "zeitwerk"
loader = Zeitwerk::Loader.for_gem
loader.push_dir(__dir__)
loader.setup

module Rakish

  def self.run
    Loader.init
    run Global.instance.app
  end

  def self.init(**kwargs)
    Loader.init(**kwargs)
  end

  def self.prep(**kwargs)
    Loader.prep(**kwargs)
  end

  def self.app
    Application.new(
      Global.instance.app,
      Global.instance.config
    )
  end
end










# require 'loader'
# require "zeitwerk"
# # require 'logger'
# # require 'singleton'
# # require 'initializer'

# module Rakish
# end
