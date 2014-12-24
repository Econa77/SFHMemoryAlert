Pod::Spec.new do |spec|
  spec.platform = :ios
  spec.name         = 'SFHMemoryAlert'
  spec.version      = '0.0.1'
  spec.license      = { :type => 'MIT' }
  spec.homepage     = 'https://github.com/Econa77/SFHMemoryAlert'
  spec.authors      = { 'Shunsuke Furubayashi' => 'f.s.1992.ip@gmail.com' }
  spec.summary      = 'Show simple memory alert fot your iOS app.'
  spec.source       = { :git => 'https://github.com/Econa77/SFHMemoryAlert.git', :tag => '0.0.1' }
  spec.source_files = 'SFHMemoryAlert/*.{h,m}'
  spec.frameworks = 'UIKit', 'Foundation'
  spec.resources = 'SFHMemoryAlert/SFHMemoryAlert.bundle'
  spec.requires_arc = true
end
