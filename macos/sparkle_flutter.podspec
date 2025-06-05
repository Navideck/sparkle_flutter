Pod::Spec.new do |s|
  s.name             = 'sparkle_flutter'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin project.'
  s.description      = <<-DESC
A new Flutter plugin project.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }

  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform = :osx, '10.11'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES'  }
  s.swift_version = '5.0'
  if ENV['ENABLE_SPARKLE'] == '1'
    s.dependency 'Sparkle'
    s.pod_target_xcconfig = { 
      'DEFINES_MODULE' => 'YES',
      'SWIFT_ACTIVE_COMPILATION_CONDITIONS' => 'ENABLE_SPARKLE'
    }
  end
end
