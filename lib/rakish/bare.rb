class Bare
  def initialize
    @router ||= Router.new
  end

  def call(...)
    @router.call(...)
  end
end
