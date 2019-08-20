Pod::Spec.new do |s|
  s.name         = "CocoaLogKit"
  s.version      = "1.0.0"
  s.summary      = "Log framework based on CocoaLumberjack and ZipArchive"
  s.homepage     = "https://github.com/skooal/LogKit"
  s.license      = "MIT"
  s.author       = { "BANYAN" => "greenbanyan@163.com" }
  s.platform     = :ios,'8.0'
  s.source       = { :git => "https://github.com/skooal/LogKit.git", :tag => s.version }
  s.source_files = "CocoaLogKit/**/*.{h,m}"
  s.resource     = "CocoaLogKit/LogKit.bundle"
  "public_header_files": [
    "CocoaLogKit/LogKit.h"
  ],
  s.dependency 'CocoaLumberjack/Swift'
  s.dependency 'SSZipArchive'
  "frameworks": [
    "UIKit",
    "Foundation",
    "MessageUI"
    ],
  s.requires_arc = true
end
