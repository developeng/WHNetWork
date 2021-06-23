Pod::Spec.new do |spec|

  spec.name         = "WHNetWork"
  spec.version      = "0.0.1"
  spec.summary      = "Basic WHNetWork"
  spec.description  = <<-DESC
                    This is a basic component library
                   DESC

  spec.homepage     = "https://github.com/developeng/WHNetWork"
  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }
  spec.author             = { "developeng" => "developeng@163.com" }
  spec.swift_version  = '5.4', '5.0'
  spec.platform     = :ios, "11.0"
  spec.source       = { :git => "https://github.com/developeng/WHNetWork.git", :tag => "#{spec.version}" }
  spec.source_files  = "WHNetWork/Network/*"


  spec.dependency "Alamofire", "~> 5.2.0"
  spec.dependency "Moya", "~> 14.0.0"
  spec.dependency "HandyJSON", "5.0.1"
  spec.dependency "WHBaseControl", :git => "https://github.com/developeng/WHBaseControl.git"

end
