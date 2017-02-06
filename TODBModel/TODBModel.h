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


+ (id)crateModel;
+ (NSArray *)crateModels:(NSUInteger)count;


- (void)save;
- (void)save:(void(^)(TODBModel *model))block;

- (void)del;
- (void)del:(void(^)(TODBModel *model))block;


@end
