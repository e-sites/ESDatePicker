Pod::Spec.new do |s|
  s.name           = "ESDatePicker"
  s.version        = "1.3"
  s.platform       = :ios, "7.0"
  s.summary        = "Again another date picker"
  s.author         = { "Bas van Kuijck" => "bas@e-sites.nl" }
  s.license        = { :type => "BSD", :file => "LICENSE" }
  s.homepage       = "https://github.com/e-sites/ESDatePicker"
  s.source         = { :git => "https://github.com/e-sites/ESDatePicker.git", :tag => s.version.to_s }
  s.source_files   = "ESDatePicker/*.{h,m}"
  s.requires_arc   = false
  s.dependency 'ESDateHelper', '~> 1.2'
  s.dependency 'ESObjectPool', '~> 1.3'
  s.dependency 'Masonry', '~> 0.5'
end
