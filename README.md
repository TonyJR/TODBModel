# TODBModel 

[![CocoaPods](https://img.shields.io/cocoapods/v/TODBModel.svg?style=flat)](http://cocoapods.org/?q=name%3ATODBModel)
[![CocoaPods](https://img.shields.io/cocoapods/p/TODBModel.svg?style=flat)](https://github.com/TonyJR/TODBModel)
[![CocoaPods](https://img.shields.io/cocoapods/at/TODBModel.svg?style=flat)](http://cocoapods.org/?q=name%3ATODBModel)
[![CocoaPods](https://img.shields.io/cocoapods/dt/TODBModel.svg?style=flat)](https://github.com/TonyJR/TODBModel)
[![CocoaPods](https://img.shields.io/cocoapods/l/TODBModel.svg?style=flat)](https://github.com/TonyJR/TODBModel/blob/master/LICENSE)

==============


TODBModel是基于FMDB开发的数据库模型系统，它把数据库操作完全融入模型中。该类的任何子类将自动创建并维护数据库，无需懂得任何SQL语法及概念即可进行数据库操作。支持字符串、整型、浮点型、NSData、NSDate、UIImage、NSArray、NSDictionary存储。

模型缓存+数据库异步读写，创建1000条数据仅需0.02秒。

关于对“事物”的支持问题，我考虑了很久，最终还是放弃了。并不是技术上无法实现。TODBModel并不是数据库的延伸，而是一种数据存储方案，这种方案是提供给那些希望简单的存储数据的场景的，我会尽量屏蔽数据库的概念简化操作流程，让使用者感觉在操作面向对象的model，而不是更加抽象的数据表。

在使用TODBModel时，大多数情况下用户都是在操作内存模型。模型的增删改功能也是同步操作内存模型的动作，数据库操作是在模型操作完成后异步完成的（将操作动作转换为SQL语句，等待队列执行），因此用户并不需要担心因为多线程操作导致的数据错误或者执行顺序与预期不符的情况。

![image](https://github.com/TonyJR/TODBModel/blob/master/1.gif)

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

@interface AddressModel : NSObject

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

+ (void)initialize{
   //在数据库中注册数据表
   [self regiestDB];
}

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
[model save:^(TODBModel *model) {
    //保存成功
}]
//删除
[model del:^(TODBModel *model) {
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
TODBCondition *condition1 = [TODBCondition condition:@"name" like:@"%123%"];
TODBCondition *condition2 = [TODBCondition condition:@"mobile" like:@"%123%"];
[AddressModel search:[TODBOrCondition conditionWith:condition1 or:condition2] callBack:^(NSArray<TODBModel *> *models) {
    //搜索完成
}];
```
6、内存索引
```
+ (nonnull instancetype)modelByKey:(nonnull id)modelKey;
+ (nullable instancetype)modelByKey:(nonnull id)modelKey allowNull:(BOOL)allowNull;
```
上面两个方法会现在内存中搜索以key为主键的model，如果内存中不存在，则在数据库中搜索，如果数据库中也不存在则根据allowNull参数决定是否创建空model
[TestModel modelByKey:@"key"] 等价于 [TestModel modelByKey:@"key" allowNull:NO]

由于使用了内存索引，所以不建议通过new或alloc方法来创建model，创建model的方法有三种。

+ 前面介绍的
```
[TestModel modelByKey:@"key" allowNull:YES];
```
可以在检查搜索后创建指定主键的model
+ 使用自增长主键，创建单个模型。当需要创建多个模型时，crateModel效率并不高，建议使用crateModels

```
TestModel *model = [TestModel crateModel];
```
+ 使用自增长主键，批量创建模型。
```
NSArray<TestModel *> *models = [TestModel crateModels:100];
```


Swift
------------
在Swift中，非指针对象（Int,Float,Double,Boolean等）请不要使用“？”、“！”修饰属性。否则可能导致该字段无法插入数据库
```swift
//  AddressModel.swift

import UIKit
import TODBModel

class AddressModel: TODBModel {
    var name: String = "";
    var addressID: Int = 0;
    var age: Float = 0;

    var editDate: NSDate!;
    var mobile: String!;
    var address: String!;

    public static override func db_pk() -> String{
        return "addressID";
    }
}
```
特别说明
------------
TOBDModel的设计基于内存+外存两部分，id相同的model在内存中只会存在一个。您可以在多个controller中持有同一个model，使用KVO或者RAC方便的同步数据。
+ 详见内存索引部分

更新日志
------------
version 1.3.0
```
0、增加分页功能
```

version 1.2.2
```
0、当模型属性中包含未创建数据表的自定义对象时，直接把对象序列化存储为BLOB列中。该对象会检测是否支持NSCoding协议，如果未支持则会自动实现协议。
1、修复了一个FMDB中的一个bug——释放FMResultSet对象时使用的线程与查询时不同，导致插入操作如果过于频繁可能导致崩溃。
```

version 1.2.1
```
0、修复了一个模型嵌套时无法保存的问题。
```

version 1.2.0
```
0、当N个模型分别update时，现在会自动合并sql处理，大幅提高了写入速度。
1、分离了数据表读取和生成模型的线程，提高了并发处理时的读取速度。
2、对模型属性进行缓存，现在每1万条记录读取速度小于1秒（iphone6测试0.83秒）
```

version 1.0.0
```
0、移除了TODBModel类，现在任何NSObject的子类都可以直接存入数据库
1、新增了更新表结构的方法，现在不再自动更新表结构了，而是需要手动更新
```

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
0、自动创建、维护模型对应的数据库。启动时检测模型变化，如属性发生变更则自动更新数据表。
1、支持NSString、NSDate、NSData、CGFloat、NSInteger、float、double等基本类型。
2、支持任何实现了NSCoding接口的对象。
3、特别优化了TODBModel的子类作为属性的支持。
```
