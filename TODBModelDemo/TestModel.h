//
//  TestModel.h
//  TODBModel
//
//  Created by Tony on 16/11/22.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TODBModel.h"
#import "TODBModel+Cache.h"

@interface TestModel : TODBModel{
@private
    int *privateName;
}

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) int intValue;
@property (nonatomic,strong) NSDate *test;
@property (nonatomic,strong) UIImage *image;

@property (nonatomic,strong) TestModel *model;

@end
