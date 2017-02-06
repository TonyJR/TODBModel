//
//  TODBModel+Cache.h
//  TODBModel
//
//  Created by Tony on 16/11/29.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "TODBModel.h"

@interface TODBModel (Cache)

+ (id)modelByDic:(NSDictionary *)dic;

+ (instancetype)memoryByKey:(id)modelKey;

+ (instancetype)modelByKey:(id)modelKey;
+ (instancetype)modelByKey:(id)modelKey allowNull:(BOOL)allowNull;
+ (void)saveModelByKey:(id)modelKey model:(TODBModel *)model;

@end
