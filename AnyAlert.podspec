Pod::Spec.new do |s|
  s.name        = "AnyAlert"
  s.version     = "4.0.2"
  s.summary     = "Customizable Alert message for Swift"
  s.homepage    = "https://github.com/ChrisAllinson/AnyAlert-iOS/tree/4.0.2/AnyAlert/AnyAlert"
  s.license     = { :type => "MIT", :file => "AnyAlert/AnyAlert/LICENSE.txt" }
  s.authors     = { "ChrisAllinson" => "allinson.ca@hotmail.com" }

  s.requires_arc = true
  s.ios.deployment_target = "13.0"
  s.swift_version = "5.0"
  s.source   = { :git => "https://github.com/ChrisAllinson/AnyAlert-iOS.git", :branch => 'master', :tag => s.version }
  s.source_files = "AnyAlert/AnyAlert/*.{swift}", "AnyAlert/AnyAlert/README.md", "AnyAlert/AnyAlert/LICENSE.txt"
  s.resources = 'AnyAlert/AnyAlert/*.{storyboard}'
end
