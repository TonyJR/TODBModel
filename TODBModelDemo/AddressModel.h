//
//  AddressModel.h
//  TODBModel
//
//  Created by Tony on 17/2/5.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "TODBModel.h"

@interface AddressModel : TODBModel

@property (nonatomic,strong) NSString *name;
@property (nonatomic,assign) int addressID;
@property (nonatomic,strong) NSDate *editDate;
@property (nonatomic,strong) NSString *mobile;
@property (nonatomic,strong) NSString *address;

@end
