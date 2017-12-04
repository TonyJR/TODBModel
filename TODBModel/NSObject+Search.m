//
//  NSObject+Search.m
//  TODBModel
//
//  Created by Tony on 2017/8/30.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "NSObject+Search.h"
#import "NSObject+TODBModel.h"
#import <objc/runtime.h>



@implementation NSObject (Search)

+ (NSLock *)searchLock{
    static NSLock *lock;
    if (!lock) {
        lock = [[NSLock alloc] init];
    }
    
    return lock;
}

+ (NSArray *)allModels{
    [[self searchLock] lock];
    NSArray *result = [self db_search:[NSString stringWithFormat:@"SELECT * FROM %@" ,[self db_name]]];
    [[self searchLock] unlock];
    
    return result;
}
+ (void)allModels:(void(^)(NSArray<NSObject *> *models))block{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self searchLock] lock];
        
        __block  NSArray *result = [self db_search:[NSString stringWithFormat:@"SELECT * FROM %@" ,[self db_name]]];
        
        
        [[self searchLock] unlock];
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result);
            });
        }
    });
}

+ (void)removeAll:(void(^)())block{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [self db_dropTable];
        [self regiestDB];
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block();
            });
        }
    });
}

+ (NSArray *)search:(id<TODBConditionBase>)condition{
    [[self searchLock] lock];
    
    NSArray *result = [self db_condition_search:condition];
    
    [[self searchLock] unlock];
    return result;
}

+ (void)search:(id<TODBConditionBase>)condition callBack:(void(^)(NSArray<NSObject *> *models))block{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self searchLock] lock];
        
        __block NSArray<NSObject *> *result = [self db_condition_search:condition];
        [[self searchLock] unlock];
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result);
            });
        }
        
        
    });
}

+ (NSArray *)searchSQL:(NSString *)sqlString{
    [[self searchLock] lock];
    
    NSArray *result = [self db_search:sqlString];
    [[self searchLock] unlock];
    return result;
}

+ (void)searchSQL:(NSString *)sqlString callBack:(void(^)(NSArray<NSObject *> *models))block{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [[self searchLock] lock];
        
        __block NSArray *result = [self db_search:sqlString];
        
        [[self searchLock] unlock];
        
        if (block) {
            dispatch_async(dispatch_get_main_queue(), ^{
                block(result);
            });
        }
    });
}

@end
