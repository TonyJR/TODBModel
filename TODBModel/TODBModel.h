//
//  TODBModel.h
//  TODBModel
//
//  Created by Tony on 16/11/22.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODataBase.h"


@interface TODBModel : NSObject<TODataBase>

/**
 Create a new model.
 */
+ (id)crateModel;

/**
 Create a number of models.

 @param count create number.
 @return created models.
 */
+ (NSArray *)crateModels:(NSUInteger)count;


/**
 Save a model to database synchronously.
 */
- (void)save;

/**
 Save a model to database asynchronously.

 @param block finish callback.
 */
- (void)save:(void(^)(TODBModel *model))block;

/**
 Delete a model from database synchronously.
 */
- (void)del;

/**
 Delete a model from database synchronously.
 
 @param block finish callback.
 */
- (void)del:(void(^)(TODBModel *model))block;


@end

