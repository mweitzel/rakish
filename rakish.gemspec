Gem::Specification.new do |s|
  s.name        = "rakish"
  s.version     = "0.0.0"
  s.summary     = "Reload rack-ish things!"
  s.description = "??"
  s.authors     = ["Matthew"]
  s.email       = "matthew@example.com"
  s.files       = Dir['rakish/**/*.rb']
  s.add_dependency "zeitwerk"
  s.add_dependency "concurrent-ruby"
  s.homepage    = "https://github.com/mweitzel/rakish"
  s.license     = "MIT"
end
