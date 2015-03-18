Pod::Spec.new do |s|
  s.name         = "YammerSDK"
  s.version      = "0.0.1"
  s.summary      = "A thin wrapper around the Yammer oauth authentication system"

  s.description  = <<-DESC
                    A thin wrapper around the Yammer oauth authentication system.
                    Allows user to easily authenticate with the Yammer API.
                   DESC
  s.homepage     = "https://github.com/yammer/ios-oauth-demo"
   s.license      = { :type => "Apache License", :file => "LICENSE" }

  s.author             = "Dave Weston"
   s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/cotap/ios-oauth-demo.git", :tag => "0.0.1" }
  s.source_files  = "OAuthSDK/*.{h,m}"
  s.dependency  'AFNetworking', '~> 2.0'
  s.dependency  'PDKeychainBindingsController', '0.0.1'
  s.dependency  'RequestUtils', '1.1'

end
