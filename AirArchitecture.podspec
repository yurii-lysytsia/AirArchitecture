#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.name         = "AirArchitecture"
  spec.version      = "0.3.0"
  spec.summary      = "Abstract classes to faster start of project coding!"
  spec.description  = "This framework contains different architecture pattern components, such as coordinator, MVC, MVP, MVVM and other base classes"
  spec.homepage     = "https://github.com/yurii-lysytsia/AirArchitecture"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.license      = { :type => "MIT", :file => "LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.author             = { "Yurii Lysytsia" => "developer.yurii.lysytsia@gmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.ios.deployment_target = "9.0"
  spec.swift_versions = '5.0'
  
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.source       = { :git => "https://github.com/yurii-lysytsia/AirKit.git", :tag => "#{spec.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  spec.default_subspecs = :none

  spec.subspec "Coordinator" do |coordinator|
    coordinator.source_files = "AirArchitecture/Coordinator/Sources/**/*.swift"
  end

end
