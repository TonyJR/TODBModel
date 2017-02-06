Pod::Spec.new do |s|
s.name             = "TODBModel"
s.version          = "0.2"
s.summary          = "Make database like a model"
s.description      = <<-DESC
TODBModel是基于FMDB开发的数据库模型系统，它把数据库操作完全融入模型中。该类的任何子类将自动创建并维护数据库，无需懂得任何SQL语法及概念即可进行数据库操作。
DESC
s.homepage         = "https://github.com/TonyJR/TODBModel.git"
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { "Tony.JR" => "show_3@163.com" }
s.source           = { :git => "https://github.com/TonyJR/TODBModel.git", :tag => "#{s.version}" }
s.platform         = :ios, '0.2'           
s.requires_arc     = true  
             
s.source_files     = 'TODBModel/TODBModel/*.{h,m}, TODBModel/TODBModel/conditions/*.{h,m}'


s.frameworks       = 'Foundation'

s.dependency        'FMDB'

end