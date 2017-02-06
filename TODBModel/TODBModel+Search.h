//
//  TODBModel+Search.h
//  TODBModel
//
//  Created by Tony on 17/1/5.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "TODBModel.h"
#import "TODBCondition.h"

@interface TODBModel (Search)


+ (NSArray *)allModels;
+ (void)allModels:(void(^)(NSArray<TODBModel *> *models))block;

+ (NSArray *)search:(id<TODBConditionBase>)condition;
+ (void)search:(id<TODBConditionBase>)condition callBack:(void(^)(NSArray<TODBModel *> *models))block;

+ (NSArray *)searchSQL:(NSString *)sqlString;
+ (void)searchSQL:(NSString *)sqlString callBack:(void(^)(NSArray<TODBModel *> *models))block;



@end
