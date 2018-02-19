Pod::Spec.new do |s|
  s.name        = "AnyAlert"
  s.version     = "1.0.0"
  s.summary     = "Customizable Alert message for Swift"
  s.homepage    = "https://github.com/ChrisAllinson/AnyAlert"
  s.license     = { :type => "MIT" }
  s.authors     = { "ChrisAllinson" => "allinson.ca@hotmail.com" }

  s.requires_arc = true
  s.ios.deployment_target = "9.0"
  s.source   = { :git => "https://github.com/ChrisAllinson/AnyAlert.git", :branch => 'master-xcode-8', :tag => s.version }
  s.source_files = "AnyAlert/AnyAlert/*.{swift}"
  s.resources = 'AnyAlert/AnyAlert/*.{storyboard}'
end