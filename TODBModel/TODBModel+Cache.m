//
//  TODBModel+Cache.m
//  TODBModel
//
//  Created by Tony on 16/11/29.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "TODBModel+Cache.h"
#import <ReactiveCocoa.h>
#import <objc/runtime.h>
#import "TODataTypeHelper.h"

@interface TODBModel ()

@property (nonatomic,strong) NSString *dbCacheKey;

@end

@implementation TODBModel (Cache)

static NSMapTable * cache;

+ (void)load{
    if (!cache) {
        cache = [NSMapTable mapTableWithKeyOptions:NSPointerFunctionsCopyIn valueOptions:NSPointerFunctionsWeakMemory];
    }
}

//获取模型
+ (instancetype)modelByKey:(NSString *)modelKey{
    return [self modelByKey:modelKey allowNull:NO];
}

//获取模型
+ (instancetype)modelByKey:(NSString *)modelKey allowNull:(BOOL)allowNull{
    if (!modelKey || modelKey.length == 0) {
        return nil;
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

+ (void)saveModelByKey:(NSString *)modelKey model:(TODBModel *)model{
    if (modelKey && modelKey.length > 0) {
        [cache setObject:model forKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass(self),modelKey]];
    }
}



//模型初始化
- (id)init{
    self = [super init];
    if (self) {
        @weakify(self);
        
        [[self rac_valuesForKeyPath:[[self class] db_pk] observer:self] subscribeNext:^(id x) {
            @strongify(self);
            NSString *key = nil;

            if (x) {
                key = [NSString stringWithFormat:@"%@",x];
            }

            self.dbCacheKey = key;
            
        }];
    }
    return self;
}


- (void)setDbCacheKey:(NSString *)dbCacheKey{
    objc_setAssociatedObject(self, "dbCacheKey", dbCacheKey, OBJC_ASSOCIATION_COPY);

    NSString *_dbCacheKey = [self dbCacheKey];
    
    
    if (_dbCacheKey && _dbCacheKey.length!= 0) {
        if ([_dbCacheKey isEqualToString:dbCacheKey]) {
            return;
        }
        [cache removeObjectForKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),_dbCacheKey]];
    }
    
    if (dbCacheKey && dbCacheKey.length!= 0) {
        [cache setObject:self forKey:[NSString stringWithFormat:@"%@_%@",NSStringFromClass([self class]),dbCacheKey]];
    }
}

- (NSString *)dbCacheKey{
    return objc_getAssociatedObject(self, "dbCacheKey");
}




@end
