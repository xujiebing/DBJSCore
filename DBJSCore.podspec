
Pod::Spec.new do |s|
  s.name             = 'DBJSCore'
  s.version          = '0.1.0'
  s.summary          = 'A short description of DBJSCore.'
  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/xujiebing/DBJSCore'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'xujiebing' => 'xujiebing@bwton.com' }
  s.source           = { :git => 'https://github.com/xujiebing/DBJSCore.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'DBJSCore/Classes/**/*'
  s.resources = 'DBJSCore/Assets/DBJSCore.bundle'
  
  # s.resource_bundles = {
  #   'DBJSCore' => ['DBJSCore/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
