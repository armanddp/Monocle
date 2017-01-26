Pod::Spec.new do |s|
  s.name = 'Monocle'
  s.version = '1.0'
  s.summary = 'iOS player for circular video shot with Snapchat Spectacles.'
  s.homepage = 'http://github.com/gizmosachin/Monocle'
  s.license = 'MIT'
  s.social_media_url = 'http://twitter.com/gizmosachin'
  s.author = { 'Sachin Patel' => 'me@gizmosachin.com' }
  s.source = { :git => 'https://github.com/gizmosachin/Monocle.git', :tag => s.version }
  s.ios.deployment_target = '9.0'
  s.source_files = 'Sources/*.swift'
  s.requires_arc = true
  s.frameworks = 'Foundation', 'UIKit', 'CoreGraphics', 'CoreMotion', 'AVFoundation'
end
