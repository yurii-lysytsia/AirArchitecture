#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  spec.name = "AirArchitecture"
  spec.version = "0.4.0"
  spec.summary = "Abstract classes to speed up your coding time!"
  spec.description = "This framework contains different architecture pattern components, such as coordinator, MVC, MVP, MVVM and other base classes"
  spec.homepage     = "https://github.com/yurii-lysytsia/#{spec.name}"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Licensing your code is important. See https://choosealicense.com for more info.
  #  CocoaPods will detect a license file if there is a named LICENSE*
  #  Popular ones are 'MIT', 'BSD' and 'Apache License, Version 2.0'.
  #

  spec.license = { :type => "MIT", :file => "LICENSE" }

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the authors of the library, with email addresses. Email addresses
  #  of the authors are extracted from the SCM log. E.g. $ git log. CocoaPods also
  #  accepts just a name if you'd rather not provide an email address.
  #
  #  Specify a social_media_url where others can refer to, for example a twitter
  #  profile URL.
  #

  spec.author = { "Yurii Lysytsia" => "developer.yurii.lysytsia@gmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If this Pod runs only on iOS or OS X, then specify the platform and
  #  the deployment target. You can optionally include the target after the platform.
  #

  spec.ios.deployment_target = "12.0"
  spec.swift_versions = '5.7'
  
  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  spec.source = { :git => "https://github.com/yurii-lysytsia/#{spec.name}.git", :tag => "#{spec.version}" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any swift, h, m, mm, c & cpp files.
  #  For header files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  # Remove prefix header file and select custom module map to avoid redundant UIKit import
  spec.prefix_header_file = false
  spec.module_map = "#{spec.name}.modulemap"

  # ――― Source Code (Core) ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  spec.default_subspecs = "Nibless", "Coordinator"

  spec.subspec "Umbrella" do |subspec|
    subspec.source_files = "#{spec.name}-umbrella.h"
  end

  spec.subspec "Nibless" do |subspec|
    subspec.dependency "#{spec.name}/Umbrella"
    subspec.source_files = "#{spec.name}/Nibless/**/*.swift"
  end

  spec.subspec "Coordinator" do |subspec|
    subspec.dependency "#{spec.name}/Umbrella"
    subspec.source_files = "#{spec.name}/Coordinator/**/*.swift"
  end
end
