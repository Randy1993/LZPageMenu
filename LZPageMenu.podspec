#
#  Be sure to run `pod spec lint LZPageMenu.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  
  s.name         = "LZPageMenu"
  s.version      = "2.0.0"
  s.summary      = "一个功能强大的控制器分段"
  s.homepage     = "https://github.com/Randy1993/LZPageMenu"
  s.license      = "MIT"
  s.author             = { "柳振" => "211752656@qq.com" }
  s.social_media_url   = "https://www.jianshu.com/u/e49f5001aa1b"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/Randy1993/LZPageMenu.git", :tag => "#{s.version}" }
  s.source_files  = "LZPageMenuClasses", "LZPageMenuClasses/*.{h,m}"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true
  
  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

end
