//
//  NSObject+TODBModel.h
//  TODBModel
//
//  Created by Tony on 2017/8/30.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODataBase.h"

@interface NSObject (RegiestDB)<TODataBase>

@property (nonatomic,assign) NSUInteger pk;


/**
 Did existed table in database
 */
+ (BOOL)existDB;

/**
 Create or update table for this class.
 */
+ (void)regiestDB;

/**
 Create a new model.
 */
+ (id)crateModel;

/**
 Create a number of models synchronously.
 
 @param count create number.
 @return created models.
 */
+ (NSArray *)crateModels:(NSUInteger)count;

/**
 Create a number of models asynchronously.
 
 @param count create number.
 @return created models.
 */
+ (void)crateModels:(NSUInteger)count callback:(void(^)(NSArray *models,NSError *error))block;

/**
 Save a model to database synchronously.
 */
- (void)save;

/**
 Save a model to database asynchronously.
 
 @param block finish callback.
 */
- (void)save:(void(^)(NSObject *model))block;

/**
 Delete a model from database synchronously.
 */
- (void)del;

/**
 Delete a model from database synchronously.
 
 @param block finish callback.
 */
- (void)del:(void(^)(NSObject *model))block;

- (void)db_setValue:(id)value forKey:(NSString *)key;


@end
