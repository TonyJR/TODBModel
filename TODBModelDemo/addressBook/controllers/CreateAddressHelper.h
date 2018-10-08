//
//  CreateAddressHelper.h
//  TODBModel
//
//  Created by TonyJR on 2018/10/8.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AddressModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CreateAddressHelper : NSObject

+ (NSArray<AddressModel *> *)createAddress:(NSUInteger)count;

@end

NS_ASSUME_NONNULL_END
