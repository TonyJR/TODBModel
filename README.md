# TODBModel
==============

TODBModel是基于FMDB开发的数据库模型系统，它把数据库操作完全融入模型中。该类的任何子类将自动创建并维护数据库，无需懂得任何SQL语法及概念即可进行数据库操作。

功能列表
------------
version 0.1.1
0、增加数据删除功能
1、修复一个初始化阶段导致死循环的bug

version 0.1
0、数据增、改、查，（删暂未实现）。
1、自动创建、维护模型对应的数据库。启动时检测模型变化，如属性发生变更则自动更新数据表。
2、支持NSString、NSDate、NSData、CGFloat、NSInteger、float、double等基本类型。
3、支持任何实现了NSCoding接口的对象。
4、特别优化了TODBModel的子类作为属性的支持。

特别说明
------------
TODBModel基于内存唯一原理设计，因此请不要使用alloc方式创建对象，而应该使用-modelByKey:或者-modelByKey: allowNull:来获取获取对象。
多次调用-modelByKey:来获取同一key对应的对象时，将获得指向同一内存地址的指针实例。
