//
//  AddressModel.m
//  TODBModel
//
//  Created by Tony on 17/2/5.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "AddressModel.h"

@implementation AddressModel

+ (void)load{
    [self regiestDB];
}

+ (NSString *)db_pk{
    return @"addressID";
}



@end
