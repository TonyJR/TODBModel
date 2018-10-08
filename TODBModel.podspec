#
#  Be sure to run `pod spec lint TODBModel.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "TODBModel"
<<<<<<< HEAD
  s.version      = "1.2.0"
=======
  s.version      = "1.1.3"
>>>>>>> e5534496c978d5f6f41309e0416fea3493a55138
  s.summary      = "A thread-safe ORM, base on sqlite and FMDB."

  s.description  = <<-DESC
TODBModel是基于FMDB开发的数据库模型系统，它把数据库操作完全融入模型中。该类的任何子类将自动创建并维护数据库，无需懂得任何SQL语法及概念即可进行数据库操作。
                   DESC

  s.homepage     = "https://github.com/TonyJR/TODBModel.git"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { "Tony.JR" => "show_3@163.com" }
  s.platform     = :ios, "7.0"
  s.source           = { :git => "https://github.com/TonyJR/TODBModel.git", :tag => "#{s.version}" }
  s.requires_arc     = true        
  s.source_files     = 'TODBModel/*.{h,m}'
  s.frameworks       = 'Foundation'
  s.dependency        'FMDB'
  

end


