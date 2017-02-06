//
//  TODataTypeHelper.h
//  TODBModel
//
//  Created by Tony on 16/11/28.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

#ifndef objcType2SqlType

#define objcType2SqlType(type) [TODataTypeHelper objcTypeToSqlType:type]

#endif

#define DB_TYPE_INTEGER     @"INTEGER"
#define DB_TYPE_REAL        @"REAL"
#define DB_TYPE_TEXT        @"TEXT"
#define DB_TYPE_BLOB        @"BLOB"

#define DB_NULL             @"null"



@interface TODataTypeHelper : NSObject

//将objc类型转化为Sqllite对应的类型
+ (NSString *)objcTypeToSqlType:(const char *)objcType;

+ (NSString *)objcObjectToSqlObject:(id)objcObject  withType:(NSString *)type arguments:(NSMutableArray *)arguments;

+ (id)readObjcObjectFrom:(FMResultSet *)resultSet name:(NSString *)name type:(NSString *)objcType;

//筛选NSArray，NSDictionary
+ (NSArray *)copyArray:(NSArray *)array;

+ (NSDictionary *)copyDictionary:(NSDictionary *)array;

@end
