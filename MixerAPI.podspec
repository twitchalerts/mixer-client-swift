Pod::Spec.new do |s|
  s.name       = "MixerAPI"
  s.version    = "1.6.5"
  s.summary    = "An interface to communicate with Mixer's backend."
  s.homepage   = "https://github.com/mixer/mixer-client-swift"
  s.license    = "MIT"
  s.author     = { "Jack Cook" => "jack@mixer.com" }

  s.requires_arc           = true
  s.ios.deployment_target  = "10.0"
  s.source                 = { :git => "https://github.com/mixer/mixer-client-swift.git", :tag => "1.6.5" }
  s.source_files           = "Pod/Classes/**/*"

  s.dependency "Starscream", "~> 3.0.6"
  s.dependency "SwiftyJSON", "~> 5.0"
end
