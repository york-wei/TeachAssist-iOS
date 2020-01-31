# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'TeachAssist' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for TeachAssist
  pod 'SwiftSoup'
  pod 'IQKeyboardManagerSwift'
  pod 'ViewAnimator'
  pod 'Charts'
  pod 'Siren'
  pod 'BulletinBoard'

  target 'TeachAssistTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'TeachAssistUITests' do
    inherit! :search_paths
    # Pods for testing
  end
  
  target 'TeachAssist-Widget' do
    inherit! :search_paths
  end

end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    next unless target.name == 'SwiftSoup'
    target.build_configurations.each do |config|
      next unless config.name.start_with?('Release')
      config.build_settings['SWIFT_OPTIMIZATION_LEVEL'] = '-Onone'
    end
  end
end
