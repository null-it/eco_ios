platform :ios, '10.0'

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
  end
end

target 'carWash' do
  use_frameworks!

  source 'https://github.com/CocoaPods/Specs.git'
  source 'https://git.yoomoney.ru/scm/sdk/cocoa-pod-specs.git'
  
  pod 'Firebase/Analytics'
  pod 'Firebase/Messaging'
  
  pod 'CHIPageControl/Jalapeno'
  pod 'Cosmos', '~> 20.0'
  pod 'PromiseKit/Alamofire', '~> 6.0'
  pod 'SwiftKeychainWrapper', "~> 3.4"
  pod 'BEMCheckBox', '~> 1.4.1'
  pod "SkeletonView", '~> 1.8.5'
  pod "ReachabilitySwift"
  pod 'SwiftEntryKit', '1.2.3'
  pod "Panels", '2.1.0'
  pod "SwiftPhoneNumberFormatter"
  pod 'IQKeyboardManagerSwift'
  pod "FlagPhoneNumber"

  pod 'YooKassaPayments',
    :git => 'https://git.yoomoney.ru/scm/sdk/yookassa-payments-swift.git',
    :tag => '6.9.0'
end
