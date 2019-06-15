Pod::Spec.new do |s|
  s.name         = "CocoaLogKit"
  s.version      = "0.0.5"
  s.summary      = "Log framework based on CocoaLumberjack and ZipArchive"
  s.homepage     = "https://github.com/skooal/LogKit"
  s.license      = "MIT"
  s.author       = { "BANYAN" => "greenbanyan@163.com" }
  s.platform     = :ios,'8.0'
  s.source       = { :git => "https://github.com/skooal/LogKit.git", :tag => s.version }
  s.source_files = "LogKit/**/*.{h,m}"
  s.resource     = "LogKit/LogKit.bundle"
  s.dependency 'CocoaLumberjack', '>= 3.x'
  s.dependency 'SSZipArchive', '>= 2.x'
  s.requires_arc = true
end
