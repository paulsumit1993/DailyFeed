# Uncomment the next line to define a global platform for your project
 platform :ios, '9.3'
 pod 'RealmSwift'
target 'DailyFeed' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for DailyFeed
  pod 'lottie-ios'
  pod 'DZNEmptyDataSet'
  
  target 'DailyFeedTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'DailyFeedUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end

target 'News Now' do
  # Comment the next line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for News Now
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['SWIFT_VERSION'] = '3.0.1'
    end
  end
end
