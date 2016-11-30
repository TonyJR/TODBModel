//
//  TODBModel+Cache.h
//  TODBModel
//
//  Created by Tony on 16/11/29.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "TODBModel.h"

@interface TODBModel (Cache)

+ (instancetype)modelByKey:(NSString *)modelKey;
+ (instancetype)modelByKey:(NSString *)modelKey allowNull:(BOOL)allowNull;


@end
