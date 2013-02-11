Pod::Spec.new do |s|
  s.name         = "SpreadKit"
  s.version      = "0.0.1"
  s.summary      = "SpreadKit brings Spreadshirt API support to IOS apps."
  s.license      = 'MIT'
  s.author       = "Sebastian Marr"
  s.homepage     = 'http://developer.spreadshirt.net'
  s.source       = { :svn => 'https://svn.spreadomat.net/repos/discovery/papper-prototype/trunk/SpreadKit' }
  s.platform     = :ios, '5.0'
  s.source_files = 'SpreadKit/*'
  s.resource     = 'SpreadKitResources.bundle'
  s.requires_arc = true
  s.frameworks   = 'CoreGraphics', 'UIKit'
  s.dependency 'RestKit', '0.10.3'
  s.dependency 'GMGridView'
  s.dependency 'MAObjCRuntime'
end
