source 'https://github.com/CocoaPods/Specs.git'

platform :ios, '12.0'
use_frameworks!
inhibit_all_warnings!

def pods
  pod 'RxSwift', '~> 6'
  pod 'RxCocoa', '~> 6'
  pod 'RxKeyboard', '~> 2'
  pod 'RxDataSources', '~> 5'
  pod 'RxReachability', '~> 1.2.1'
  pod 'ReactorKit', '~> 3'
  
  pod 'Apollo', '~> 0.45.0'
  pod "Apollo/WebSocket", '~> 0.45.0'

  pod 'Firebase/Analytics', '~> 8'
  pod 'Firebase/Messaging', '~> 8'

  pod 'RealmSwift', '~> 10'

  pod 'SnapKit', '~> 5'
  pod 'Then', '~> 2.7.0'
  pod 'SwiftEntryKit', '~> 1.2.7'
  pod 'Kingfisher', '~> 6'

  pod 'CocoaLumberjack/Swift', '~> 3.7.2'
end

target 'TARAS-Dev' do
  pods
end

#target '{테스트 타겟 이름}' do
#  pods
#  pod 'RxBlocking', '~> 6'
#  pod 'RxTest', '~> 6'
#end

post_install do |installer|
   installer.pods_project.targets.each do |target|
      if target.name == 'RxSwift'
         target.build_configurations.each do |config|
            if config.name == 'Debug'
               config.build_settings['OTHER_SWIFT_FLAGS'] ||= ['-D', 'TRACE_RESOURCES']
            end
         end
      end
   end
end
