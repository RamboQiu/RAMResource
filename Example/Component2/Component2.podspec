#
# Be sure to run `pod lib lint Component2.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'Component2'
  s.version          = '0.0.1'
  s.summary          = 'A short description of Component2.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/RamboQiu/Component2.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'qiujunyun' => 'qiujunyun@163.com' }
  s.source           = { :git => 'https://github.com/RamboQiu/Component2.git', :tag => s.version.to_s }

  s.ios.deployment_target = '14.0'
  s.swift_version    = '5.0'
  s.static_framework = true
  s.module_name      = 'Component2'
  s.source_files = 'Component2/**/*'
  s.resource_bundles = {
    'Component2' => ['Component2/Assets/**/*']
  }
  s.dependency 'RAMResource'
end
