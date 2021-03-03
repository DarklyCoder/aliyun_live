#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint aliyun_live.podspec' to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'aliyun_live'
  s.version          = '0.0.1'
  s.summary          = 'A new Flutter plugin.'
  s.description      = <<-DESC
A new Flutter plugin.
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'email@example.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.public_header_files = 'Classes/**/*.h'
  s.dependency 'Flutter'
  # 播放器
  s.dependency 'AliLiveSDK_iOS', "4.0.2"
  s.dependency 'AliPlayerSDK_iOS', "5.2.3"
  s.dependency 'AliPlayerSDK_iOS_ARTC', "5.2.3"
  s.dependency 'RtsSDK','1.5.0'
  # 第三方库
  s.dependency 'AFNetworking'
  s.dependency 'SocketRocket'
  s.dependency 'SVProgressHUD'
  s.dependency 'Masonry'

  s.platform = :ios, '9.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
end
