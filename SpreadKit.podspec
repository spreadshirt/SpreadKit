Pod::Spec.new do |s|
  s.name         = "SpreadKit"
  s.version      = "0.0.1"
  s.summary      = "SpreadKit brings Spreadshirt API support to IOS apps."
  s.license      = 'MIT'
  s.author       = "Sebastian Marr"
  s.homepage     = 'http://developer.spreadshirt.net'
  s.source       = { :svn => 'https://svn.spreadomat.net/repos/discovery/papper-prototype/trunk/SpreadKit' }
  s.platform     = :ios
  s.source_files = 'SpreadKit/*'
  s.requires_arc = true
  s.dependency 'RestKit'
  s.dependency 'GMGridView'
end
