//
//  TODBModel.m
//  TODBModel
//
//  Created by Tony on 16/11/22.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "TODBModel.h"
#import <objc/runtime.h>
#import <FMDB/FMDB.h>
#import "TODBModelConfig.h"
#import "TODataTypeHelper.h"
#import "TODBPointer.h"

@interface TODBModel (){
@private
    BOOL _isLocked;
    BOOL _needUpdate;
}

@end

@implementation TODBModel

static dispatch_queue_t sql_queue;
static FMDatabase *database;

+ (void)initialize{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sql_queue = dispatch_queue_create("sql_operation_queue", DISPATCH_QUEUE_SERIAL);
        dispatch_async(sql_queue, ^{
            database = [FMDatabase databaseWithPath:TO_MODEL_DATABASE_PATH];
            [database open];
            
            NSLog(@"数据库路径:%@",TO_MODEL_DATABASE_PATH);
        });
    });
    
    NSString *db_name = [self db_name];
    if (![db_name isEqualToString:@"TODBModel"]) {
        
        //为了屏蔽NSKVONotifying_类及其他未知的覆盖操作
        if ([db_name rangeOfString:@"_"].location != NSNotFound) {
            return;
        }
        
        NSDate *date = [NSDate date];
        [self db_updateTable];
        NSLog(@"%@检查完成，用时%f",[self db_name],[[NSDate date] timeIntervalSinceDate:date]);
    }
}


#pragma mark - TODataBase
//检查并更新数据结构
+ (void)db_updateTable{
    if ([self db_existTable]) {
        NSMutableDictionary *colums;

        int result = [self checkTable:&colums];
        
        switch (result) {
            case 1:
            {
                for (NSString *name in colums.allKeys) {
                    [self addColumn:name withType:colums[name]];
                }
                break;
            }
            case 2:
            {
                NSString *tempTable = [self tempTable];
                [self createTable];
                [self copyTableFrom:tempTable toTable:[self db_name] colums:colums.allKeys];
                [self dropTable:tempTable];
            }
                break;
            
            default:
                break;
        }
        
        
        
    }else{
        [self createTable];
        
    }
}

+ (BOOL)db_existTable{
    NSString *sql = [NSString stringWithFormat:@"SELECT COUNT(*) FROM sqlite_master where type='table' and name='%@';",[self db_name]];
    
    __block int totalCount = 0;
    dispatch_sync(sql_queue, ^{
        FMResultSet *result = [database executeQuery:sql];
        if ([result next]) {
            totalCount = [result intForColumnIndex:0];
        }
    });
    if (totalCount > 0) {
        return YES;

    }else{
        return NO;
    }
}


//删除数据库
+ (void)db_dropTable{
    
}

//数据插入操作
- (void)db_update{
    NSString *pk = [[self class] db_pk];
    NSString *pv = [self valueForKey:pk];
    
    if (!pv) {
        NSException *e = [NSException
                          
                          exceptionWithName: @"数据插入错误"
                          
                          reason: @"主键不能为空"
                          
                          userInfo: nil];
        
        @throw e;
    }

    
    NSMutableString *columnName = [NSMutableString string];
    NSMutableString *columnValue = [NSMutableString string];
    
    __block NSMutableArray *objects = [NSMutableArray array];
    
    NSDictionary *sqlPropertys = [[self class] sqlPropertys];
    for (NSString *key in sqlPropertys.allKeys) {
        
        [columnName appendFormat:@"%@,",key];
        [columnValue appendFormat:@"%@,",[TODataTypeHelper objcObjectToSqlObject:[self valueForKey:key] withType:sqlPropertys[key] arguments:objects]];

    }
    
    
    if ([columnName characterAtIndex:columnName.length - 1] == ',') {
        [columnName replaceCharactersInRange:NSMakeRange(columnName.length - 1,1) withString:@""];
    }
    if ([columnValue characterAtIndex:columnValue.length - 1] == ',') {
        [columnValue replaceCharactersInRange:NSMakeRange(columnValue.length - 1,1) withString:@""];
    }
    
    __block NSString *sql = [NSString stringWithFormat:@"REPLACE INTO %@ (%@) VALUES (%@)",[[self class] db_name],columnName,columnValue];
    
    
    
    dispatch_async(sql_queue, ^{
        if ([database executeUpdate:sql withArgumentsInArray:objects] != 0) {
            
//            NSLog(@"数据库更新成功");

        }else{
            NSLog(@"数据库更新失败");
            NSLog(@"%@",sql);
        }
    });
}

////内存数据同步到数据库
//- (void)db_update{
//    
//    NSString *pk = [[self class] db_pk];
//    NSString *pv = [self valueForKey:pk];
//    
//    if (!pv) {
//        NSException *e = [NSException
//                          
//                          exceptionWithName: @"数据插入错误"
//                          
//                          reason: @"主键不能为空"
//                          
//                          userInfo: nil];
//        
//        @throw e;
//    }
//    
//    
//    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"UPDATE %@ SET ",[[self class] db_name]];
//    __block NSMutableArray *objects = [NSMutableArray array];
//    
//    NSDictionary *sqlPropertys = [[self class] sqlPropertys];
//    for (NSString *key in sqlPropertys.allKeys) {
//        [sql appendFormat:@"%@ = ",key];
//        [sql appendString:[TODataTypeHelper objcObjectToSqlObject:[self valueForKey:key] withType:sqlPropertys[key] arguments:objects]];
//        [sql appendString:@","];
//    }
//    
//    
//    if ([sql characterAtIndex:sql.length - 1] == ',') {
//        [sql replaceCharactersInRange:NSMakeRange(sql.length - 1,1) withString:@""];
//    }
//    
//    [sql appendFormat:@" where %@ = %@",pk,pv];
//    
//    
//    NSLog(@"%@",sql);
//
//    dispatch_async(sql_queue, ^{
//        if (![database executeUpdate:sql withArgumentsInArray:objects]) {
//            NSLog(@"数据库更新失败");
//        }else{
//            NSLog(@"数据库更新成功");
//        }
//    });
//}

//删除数据库内容
- (void)db_delete{
    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"DELETE FROM %@ WHERE %@ = \"%@\"",[[self class] db_name],[[self class] db_pk],[self pk]];
    
    
    
    dispatch_async(sql_queue, ^{
        BOOL result = [database executeUpdate:sql];
        
        if (result) {
//            NSLog(@"数据库删除成功");
        }else{
            NSLog(@"数据库删除失败");
            NSLog(@"%@",sql);
        }
        
    });
    
    
}

//放弃内存数据，从数据库重新读取
- (void)db_rollback{
    
}
//删除内存与数据库内容
- (void)db_destory{
    
}

//主键
+ (NSString *)db_pk{
    return @"pk";
}

+ (NSArray *)db_search:(id)value forKey:(NSString *)key{
    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"SELECT * FROM %@ WHERE %@ = ",[self db_name],key];
    NSMutableArray *result = [NSMutableArray array];
    NSMutableArray *arguments = [NSMutableArray array];
    NSString *valueStr = [TODataTypeHelper objcObjectToSqlObject:value withType:[self sqlPropertys][key] arguments:arguments];
   
    [sql appendString:valueStr];
    
    dispatch_sync(sql_queue, ^{
        FMResultSet *resultSet = [database executeQuery:sql withArgumentsInArray:arguments];
        
        if (resultSet) {
//            NSLog(@"数据库查询成功");
        }else{
            NSLog(@"数据库查询失败");
            NSLog(@"%@",sql);
        }
        
        
        NSDictionary *classPropertys = [self classPropertys];
        while ([resultSet next]) {
            id item = [[self alloc] init];
            int count = resultSet.columnCount;
            for (int i=0; i<count; i++) {
                NSString *key = [resultSet columnNameForIndex:i];
                NSString *type = classPropertys[key];
                if (key) {
                    id value = [TODataTypeHelper readObjcObjectFrom:resultSet name:key type:type];
                    [item setValue:value forKey:key];
                }
            }
            
            [result addObject:item];
        }
    });
    
    for (TODBModel *model in result) {
        [model checkPointer];
    }
    
    return result;
}

//数据库名称
+ (NSString *)db_name{
    return NSStringFromClass([self class]);
}


#pragma mark - Private

- (void)checkPointer{
    NSDictionary *dic = [[self class] classPropertys];
    for (NSString *key in dic.allKeys) {
        id value = [self valueForKey:key];
        if ([value isKindOfClass:[TODBPointer class]]) {
            value = [(TODBPointer *)value model];
        }
        
        [self setValue:value forKey:key];
    }
}

//插入字段
+ (void)addColumn:(NSString *)name withType:(NSString *)type{
    __block NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ ADD COLUMN %@ %@;",[self db_name],name,type];
    
    dispatch_async(sql_queue, ^{
        if ([database executeUpdate:sql]) {
//            NSLog(@"添加字段成功");

        }else{
            NSLog(@"添加表字段失败");
            NSLog(@"%@",sql);
        }
    });
}

//检查字段
//0不更新、1添加缺省字段、2删除重建
+ (int)checkTable:(NSMutableDictionary **)colums{
    __block NSMutableString *sql = [NSMutableString stringWithFormat:@"PRAGMA TABLE_INFO (\"%@\");",[self db_name]];
    
    NSMutableDictionary *lostColums = [NSMutableDictionary dictionary];
    NSMutableDictionary *sameColums = [NSMutableDictionary dictionary];
    
    NSMutableDictionary *tablePropertys = [NSMutableDictionary dictionary];
    dispatch_sync(sql_queue, ^{
        
        FMResultSet *result = [database executeQuery:sql];
        while ([result next]) {
            NSString *name = [result stringForColumn:@"name"];
            NSString *type = [result stringForColumn:@"type"];
            
            tablePropertys[name] = type;
        }
    });
    
    NSDictionary *sqlPropertys = [self sqlPropertys];
    
    
    int result=0;
    
    for (NSString *name in sqlPropertys.allKeys) {
        if (tablePropertys[name]) {
            [sameColums setObject:sqlPropertys[name] forKey:name];
            
            //字段已存在时，检查字段是否一样
            if (![sqlPropertys[name] isEqualToString:tablePropertys[name]]) {
                result = 2;
            }
        }else{
            if (result == 2) {
                continue;
            }
            result = 1;
            //字段不存在时，添加字段
            NSMutableDictionary *dic = lostColums;
            if (dic) {
                [dic setObject:sqlPropertys[name] forKey:name];
            }
        }
    }
    
    if (result == 2) {
        *colums = sameColums;
    }else if(result == 1){
        *colums = lostColums;
    }
    
    return result;
}

//复制table到临时table
+ (NSString *)tempTable{
    NSString *tempName = [NSString stringWithFormat:@"%@_%d",[self db_name],rand()];
    __block NSString *sql = [NSString stringWithFormat:@"ALTER TABLE %@ RENAME TO %@;",[self db_name],tempName];

    
    dispatch_sync(sql_queue, ^{
        
        if ([database executeUpdate:sql]){
//            NSLog(@"表重命名成功");
        }else{
            NSLog(@"表重命名失败");
            NSLog(@"%@",sql);
        }
    });

    
    return tempName;
}

//拷贝表
+ (void)copyTableFrom:(NSString *)table1 toTable:(NSString *)table2 colums:(NSArray<NSString *> *)colums{
    NSString *columStr = [colums componentsJoinedByString:@","];
    
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO %@ ( %@ ) SELECT %@ FROM %@;",table2 , columStr ,columStr, table1];
    dispatch_sync(sql_queue, ^{
        
        if ([database executeUpdate:sql]){
//            NSLog(@"拷贝表成功");
        }else{
            NSLog(@"拷贝表失败");
            NSLog(@"%@",sql);
        }
    });
}

//创建table
+ (void)createTable{
    __block NSString *sql = [self createTableSQL];
    
    dispatch_sync(sql_queue, ^{
        if ([database executeUpdate:sql]){
//            NSLog(@"数据表创建成功");
        }else{
            NSLog(@"数据表创建失败");
            NSLog(@"%@",sql);
        }
    });
}
//删除table
+ (void)dropTable:(NSString *)tableName{
    [database close];
    [database open];
    
    __block NSString *sql = [NSString stringWithFormat:@"DROP TABLE %@;",tableName];
    
    dispatch_sync(sql_queue, ^{
        if ([database executeUpdate:sql]){
//            NSLog(@"删除数据表成功");
        }else{
            NSLog(@"删除数据表失败");
            NSLog(@"%@",sql);
        }
    });
}

//创建table的SQL
+ (NSString *)createTableSQL{
    NSMutableString *sql = [NSMutableString stringWithFormat:@"CREATE TABLE %@ (",[self db_name]];
    
    NSDictionary *dic = [self sqlPropertys];
    for (NSString *name in dic.allKeys) {
        [sql appendFormat:@"%@ %@,",name,dic[name]];
    }
    [sql appendFormat:@"PRIMARY KEY (%@)",[self db_pk]];
    [sql appendString:@")"];
    
    return sql;
}

//objc属性名与sql属性的对应关系
+ (NSDictionary *)sqlPropertys{
    
    NSMutableDictionary *dic = objc_getAssociatedObject(self, __func__);
    
    if (dic) {
        return dic;
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        
        objc_property_t property = propertys[i];
        
        const char *name = property_getName(property);
        
        const char *type = property_copyAttributeValue(property,"T");
        
        
        NSString *sqlTypeName = objcType2SqlType(type);
        if (!sqlTypeName) {
            NSLog(@"#TOModel# %@中存在未识别的数据类型%s",NSStringFromClass([self class]),type);
        }else{
            [dic setObject:objcType2SqlType(type) forKey:[NSString stringWithUTF8String:name]];
            
        }
        
    }
    NSString *pk = [self db_pk];
    if (![dic objectForKey:pk]) {
        [dic setObject:DB_TYPE_TEXT forKey:pk];
    }
    
    objc_setAssociatedObject(self, __func__, dic, OBJC_ASSOCIATION_COPY);
    
    return dic;
}


//本地属性与类型名称的对应关系
+ (NSDictionary *)classPropertys{
    
    NSMutableDictionary *dic = objc_getAssociatedObject(self, __func__);
    
    if (dic) {
        return dic;
    }else{
        dic = [NSMutableDictionary dictionary];
    }
    
    unsigned int count;
    objc_property_t *propertys = class_copyPropertyList([self class], &count);
    for (int i = 0; i < count; i++)
    {
        
        objc_property_t property = propertys[i];
        
        const char *name = property_getName(property);
        
        const char *type = property_copyAttributeValue(property,"T");
        
        
        NSString *sqlTypeName = [NSString stringWithUTF8String:type];
        
        if (!sqlTypeName) {
            NSLog(@"#TOModel# %@中存在未识别的数据类型%s",NSStringFromClass([self class]),type);
        }else{
            [dic setObject:sqlTypeName forKey:[NSString stringWithUTF8String:name]];
        }
    }
    
    NSString *pk = [self db_pk];
    if (![dic objectForKey:pk]) {
        [dic setObject:@"@\"NSString\"" forKey:pk];
    }
    
    objc_setAssociatedObject(self, __func__, dic, OBJC_ASSOCIATION_COPY);
    
    return dic;
}

#pragma mark - KVC
- (void)setValue:(id)value forUndefinedKey:(NSString *)key{
    
}

@end
