Pod::Spec.new do |s|
  s.name        = "AnyAlert"
  s.version     = "1.1.1"
  s.summary     = "Customizable Alert message for Objective-C and Swift"
  s.homepage    = "https://github.com/ChrisAllinson/AnyAlert-iOS/tree/1.1.1/AnyAlert/AnyAlert"
  s.license     = { :type => "MIT" }
  s.authors     = { "ChrisAllinson" => "allinson.ca@hotmail.com" }

  s.requires_arc = true
  s.ios.deployment_target = "8.0"
  s.source   = { :git => "https://github.com/ChrisAllinson/AnyAlert-iOS.git", :branch => 'master-xcode-8', :tag => s.version }
  s.source_files = "AnyAlert/AnyAlert/*.{swift}"
  s.resources = 'AnyAlert/AnyAlert/*.{storyboard}'
end