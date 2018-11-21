//
//  NSObject+Cache.h
//  TODBModel
//
//  Created by Tony on 2017/8/30.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 This category will help you to search model from memory or database.
 */
@interface NSObject (Cache)


/**
 You can find/create a model with this method.
 1.If a model with same Primary Key in memory. The method will update and return it.
 2.If a model with same Primary Key in database. The method will create a model form database. Update the model and return it.
 3.Otherwise, the method will create a empty model. Update the model and return it.
 
 @param dic rarams which will update to model
 @return result of TODBModel
 */
+ (nonnull instancetype)modelByDic:(nonnull NSDictionary *)dic;


/**
 Search your memory, find a model with Primary Key.
 
 @param modelKey Primary Key
 @return result
 */
+ (nullable instancetype)memoryByKey:(nonnull id)modelKey;

+ (NSDictionary *)modelsByKeys:(NSArray *)modelKeys;

/**
 Search memory/database and return the model with same Primary Key.
 If find any model, return create a model with Primary Key in memory and return it.
 
 @param modelKey Primary Key
 @return result
 */
+ (nonnull instancetype)modelByKey:(nonnull id)modelKey;


/**
 Refer to -modelByKey: . If allowNull is NO, same to -modelByKey:.
 Otherwise may return nil.
 
 @param modelKey Primary Key
 @param allowNull allows nil return
 @return result
 */
+ (nullable instancetype)modelByKey:(nonnull id)modelKey allowNull:(BOOL)allowNull;


@end
