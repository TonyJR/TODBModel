//
//  Userinfo.m
//  TODBModel
//
//  Created by TonyJR on 2018/10/8.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "Userinfo.h"
#import "NSObject+TODBModel.h"

@implementation Userinfo

+ (void)load{
    [self regiestDB];
}

+ (NSString *)db_pk{
    return @"infoID";
}



@end
