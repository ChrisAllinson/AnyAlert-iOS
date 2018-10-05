Pod::Spec.new do |s|
  s.name        = "AnyAlert"
  s.version     = "3.1.0"
  s.summary     = "Customizable Alert message for Swift"
  s.homepage    = "https://github.com/ChrisAllinson/AnyAlert-iOS/tree/3.1.0/AnyAlert/AnyAlert"
  s.license     = { :type => "MIT" }
  s.authors     = { "ChrisAllinson" => "allinson.ca@hotmail.com" }

  s.requires_arc = true
  s.ios.deployment_target = "9.0"
  s.swift_version = "3.3"
  s.source   = { :git => "https://github.com/ChrisAllinson/AnyAlert-iOS.git", :branch => 'master', :tag => s.version }
  s.source_files = "AnyAlert/AnyAlert/*.{swift}"
  s.resources = 'AnyAlert/AnyAlert/*.{storyboard}'
end