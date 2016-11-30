//
//  TODataBase.h
//  TODBModel
//
//  Created by Tony on 16/11/22.
//  Copyright © 2016年 Tony. All rights reserved.
//

#ifndef TODataBase_h
#define TODataBase_h

@protocol TODataBase

@required
//检查并更新数据结构
+ (void)db_updateTable;
//删除数据库
+ (void)db_dropTable;

//内存数据同步到数据库
- (void)db_update;
//放弃内存数据，从数据库重新读取
- (void)db_rollback;
//删除内存与数据库内容
- (void)db_destory;

+ (NSString *)db_pk;
+ (NSArray *)db_search:(NSString *)value forKey:(NSString *)key;

@optional
+ (NSString *)db_name;

@end

#endif /* TODataBase_h */
