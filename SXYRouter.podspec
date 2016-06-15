Pod::Spec.new do |s|
  s.name         = "SXYRouter"
  s.version      = "1.0.1"
  s.ios.deployment_target = '7.0'
 # s.osx.deployment_target = '10.8'
  s.summary      = "router"
  s.homepage     = "https://github.com/wuhaizeng/SXYRouter"
  s.license      = "MIT"
  s.author             = { "wuhaizeng" => "wuhaizeng11-30@163.com" }
  s.social_media_url   = "http://weibo.com/exceptions"
  s.source       = { :git => "https://github.com/wuhaizeng/SXYRouter.git", :tag => s.version }
  s.source_files  = "Router"
  s.requires_arc = true
end
