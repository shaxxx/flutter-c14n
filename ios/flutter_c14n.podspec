#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_c14n.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_c14n'
  s.version          = '0.0.1'
  s.summary          = 'XML canonicalization for Flutter'
  s.description      = <<-DESC
  Simple wrapper for libxml2 canonicalization
                       DESC
  s.homepage         = 'https://www.integrator.hr'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Integrator Dubrovnik' => 'integrator@integrator.hr' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '8.0'

  # Flutter.framework does not contain a i386 slice. Only x86_64 simulators are supported.
  s.pod_target_xcconfig = { 
    'DEFINES_MODULE' => 'YES', 
    'VALID_ARCHS[sdk=iphonesimulator*]' => 'x86_64',
    'HEADER_SEARCH_PATHS' => '$(SDKROOT)/usr/include/libxml2',
    'OTHER_LDFLAGS' => '-lxml2'
   }
  s.library = 'xml2'
  s.swift_version = '5.0'
end
