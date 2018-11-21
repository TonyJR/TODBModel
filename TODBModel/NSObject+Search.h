//
//  NSObject+Search.h
//  TODBModel
//
//  Created by Tony on 2017/8/30.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODBCondition.h"

@interface NSObject (Search)

/**
 Find all models in database synchronously.
 
 @return all models.
 */
+ (NSArray *)allModels;


/**
 Find all models in database asynchronously.
 
 @param block finish callback.
 */
+ (void)allModels:(void(^)(NSArray<NSObject *> *models))block;

+ (void)removeAll:(void(^)(void))block;

/**
 Search models in database by condition synchronously.
 
 @param condition search condition
 @return search result
 */
+ (NSArray *)search:(id<TODBConditionBase>)condition;

/**
 Search models in database by condition asynchronously.
 
 @param condition search condition
 @param block finish callback.
 */
+ (void)search:(id<TODBConditionBase>)condition callBack:(void(^)(NSArray<NSObject *> *models))block;

/**
 Search models in database by SQL synchronously.
 
 @param sqlString search SQL
 @return search result
 */
+ (NSArray *)searchSQL:(NSString *)sqlString;

/**
 Search models in database by SQL asynchronously.
 
 @param sqlString search SQL
 @param block finish callback.
 */
+ (void)searchSQL:(NSString *)sqlString callBack:(void(^)(NSArray<NSObject *> *models))block;



@end
