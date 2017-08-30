//
//  NSObject+Cache.m
//  TODBModel
//
//  Created by Tony on 2017/8/30.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "NSObject+Cache.h"
#import "NSObject+TODBModel.h"

@implementation NSObject (Cache)

static NSMapTable * cache;

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsWeakMemory];
    });
}

#pragma mark - Public
+ (id)modelByDic:(NSDictionary *)dic{
    NSString *pkValue = dic[[self db_pk]];
    
    NSObject *model = [cache objectForKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass(self),pkValue]];
    
    if (!model) {
        model = [[self alloc] init];
    }
    
    
    for (NSString *key in dic.allKeys) {
        [model setValue:dic[key] forKey:key];
    }
    return model;
}


+ (instancetype)memoryByKey:(id)modelKey{
    id result = [cache objectForKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass(self),modelKey]];
    return result;
}
//获取模型
+ (instancetype)modelByKey:(id)modelKey{
    return [self modelByKey:modelKey allowNull:NO];
}

//获取模型
+ (instancetype)modelByKey:(id)modelKey allowNull:(BOOL)allowNull{
    if (!modelKey) {
        if (allowNull) {
            return nil;
        }else{
            return [[self alloc] init];
        }
    }
    
    id result = [cache objectForKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass(self),modelKey]];
    if (!result) {
        result = [[self db_search:modelKey forKey:[self db_pk]] lastObject];
    }
    if ((!allowNull) && (!result)) {
        result = [[self alloc] init];
        
        [result setValue:modelKey forKey:[self db_pk]];
    }
    
    return result;
}

+ (void)saveModelByKey:(id)modelKey model:(NSObject *)model{
    if (modelKey) {
        [cache setObject:model forKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass(self),modelKey]];
    }
}






//- (void)setDbCacheKey:(NSString *)dbCacheKey{
//    objc_setAssociatedObject(self, "dbCacheKey", dbCacheKey, OBJC_ASSOCIATION_COPY);
//
//    NSString *_dbCacheKey = [self dbCacheKey];
//
//
//    if (_dbCacheKey && _dbCacheKey.length!= 0) {
//        if ([_dbCacheKey isEqualToString:dbCacheKey]) {
//            return;
//        }
//        [cache removeObjectForKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),_dbCacheKey]];
//    }
//
//    if (dbCacheKey && dbCacheKey.length!= 0) {
//        [cache setObject:self forKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),dbCacheKey]];
//    }
//}
//
//- (NSString *)dbCacheKey{
//    return objc_getAssociatedObject(self, "dbCacheKey");
//}




@end
