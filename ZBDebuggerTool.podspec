#
# Be sure to run `pod lib lint ZBDebuggerTool.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ZBDebuggerTool'
  s.version          = '0.0.4'
  s.summary          = 'ZBDebuggerTool'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
ZBDebuggerTool 是检测app性能的第三方工具，包括APP性能检测、crash收集、API拦截、沙盒文件
                       DESC

  s.homepage         = 'https://github.com/lzbgithubcode/ZBDebuggerTool'
  
  s.screenshots     = 'https://github.com/lzbgithubcode/ZBDebuggerTool/raw/master/screenshotImage/result.gif'
  
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lzb' => '1835064412@qq.com' }
  s.source           = { :git => 'https://github.com/lzbgithubcode/ZBDebuggerTool.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'ZBDebuggerTool/Classes/**/*'
  
  #其他资源
  #s.resource = 'ZBDebuggerTool/Classes/**/*'
  
  # 图片资源
   s.resource_bundles = {
     'ZBDebuggerTool' => ['ZBDebuggerTool/Assets/*']
   }

  #s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
   
   # 第三方库
   s.dependency 'AFNetworking', '~> 3.2'
   s.dependency 'FMDB', '~> 2.7.2'
  
end
