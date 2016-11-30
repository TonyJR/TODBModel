//
//  TODBPointer.h
//  TODBModel
//
//  Created by Tony on 16/11/30.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TODBModel.h"

@interface TODBPointer : NSObject<NSCoding>

@property (nonatomic,strong) NSString *pkValue;
@property (nonatomic,strong) NSString *className;
@property (nonatomic,readonly) TODBModel *model;

- (instancetype)initWithModel:(TODBModel *)model;

@end
