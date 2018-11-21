//
//  AddressModel.h
//  TODBModel
//
//  Created by Tony on 17/2/5.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "NSObject+TODBModel.h"
#import "Userinfo.h"
#import "AddressInfo.h"

@interface AddressModel : NSObject

@property (nonatomic,strong) Userinfo *userinfo;
@property (nonatomic,assign) int addressID;
@property (nonatomic,strong) NSDate *editDate;
@property (nonatomic,copy) NSString *mobile;
@property (nonatomic,strong) AddressInfo *addressInfo;

@end
