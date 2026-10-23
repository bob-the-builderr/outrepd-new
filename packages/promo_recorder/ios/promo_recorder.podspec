Pod::Spec.new do |s|
  s.name             = 'promo_recorder'
  s.version          = '0.0.1'
  s.summary          = 'Films the promo app itself into Photos.'
  s.homepage         = 'https://outrepd.com'
  s.license          = { :type => 'Proprietary' }
  s.author           = { 'OUTREPD' => 'hello@outrepd.com' }
  s.source           = { :path => '.' }
  s.source_files     = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform         = :ios, '15.0'
  s.swift_version    = '5.0'
  s.frameworks       = 'ReplayKit', 'AVFoundation', 'Photos'
end
