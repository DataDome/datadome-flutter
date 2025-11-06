#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint datadome.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'datadome'
  s.version          = '1.0.0'
  s.summary          = 'A DataDome integration for Flutter.'
  s.description      = 'Protect your application with DataDome. A light bot protection solution with built-in Captcha support.'
  s.homepage         = 'https://datadome.co'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'DataDome' => 'dev@datadome.co' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'DataDomeSDK', '~> 3.8'
  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
