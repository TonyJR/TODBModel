# TODBModel 
==============
[![CocoaPods](https://img.shields.io/cocoapods/v/TODBModel.svg?style=flat)](http://cocoapods.org/?q=name%3ATODBModel)

TODBModel是基于FMDB开发的数据库模型系统，它把数据库操作完全融入模型中。该类的任何子类将自动创建并维护数据库，无需懂得任何SQL语法及概念即可进行数据库操作。支持字符串、整型、浮点型、NSData、NSDate、UIImage、NSArray、NSDictionary存储。


快速集成
------------
推荐使用cocoapod安装
```ruby
pod 'TODBModel'
```
如何使用
------------
1、创建一个对象，继承TODBModel。
2、为对象添加属性
```objc
//  AddressModel.h
#import "TODBModel.h"

@interface AddressModel : TODBModel

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) int addressID;
@property (nonatomic,strong) NSDate *editDate;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *address;

@end
```
3、覆盖+ (NSString *)db_pk方法，并返回主键对应的属性。
```objc
//  AddressModel.m
#import "AddressModel.h"

@implementation AddressModel

+ (NSString *)db_pk{
    return @"addressID";
}

@end
```
4、增删改
```objc
//创建
AddressModel *model = [AddressModel crateModel];
//保存
[self save:^(TODBModel *model) {
    //保存成功
}]
//删除
[self del:^(TODBModel *model) {
    //删除成功
}]
```
5、查询
```objc
//查询全部
[AddressModel allModels:^(NSArray<TODBModel *> *models) {
    //获取成功
}];
//搜索name中或者mobile中包含“123”的数据
TODBCondition *condition1 = [TODBCondition condition:@"name" like:[NSString stringWithFormat:@"%%%@%%",@"123"]];
TODBCondition *condition2 = [TODBCondition condition:@"mobile" like:[NSString stringWithFormat:@"%%%@%%",@"123"]];
[AddressModel search:[TODBOrCondition conditionWith:condition1 or:condition2] callBack:^(NSArray<TODBModel *> *models) {
    //搜索完成
}];
```

特别说明
------------
TODBModel基于内存唯一原理设计，因此请不要使用alloc方式创建对象，而应该使用以下方法创建
-modelByKey:
-modelByKey: allowNull:
-createModel
-createModels:
多次调用-modelByKey:来获取同一key对应的对象时，将获得指向同一内存地址的指针实例。

更新日志
------------
version 0.3
```
0、兼容swift
1、修复了使用runtime时的内存回收问题
```
version 0.2
```
0、完善了DEMO
1、新增删除
2、新增查询功能，包括模糊查询、复合条件查询
3、新增批量添加功能
4、添加对部分有较高延迟的指令的异步执行方法
5、优化了性能，修复了已知bug
```
version 0.1.1
```
0、增加数据删除功能
1、修复一个初始化阶段导致死循环的bug
```
version 0.1
```
0、数据增、改、查，（删暂未实现）。
1、自动创建、维护模型对应的数据库。启动时检测模型变化，如属性发生变更则自动更新数据表。
2、支持NSString、NSDate、NSData、CGFloat、NSInteger、float、double等基本类型。
3、支持任何实现了NSCoding接口的对象。
4、特别优化了TODBModel的子类作为属性的支持。
```
