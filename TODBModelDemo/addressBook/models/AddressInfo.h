//
//  AddressInfo.h
//  TODBModel
//
//  Created by TonyJR on 2018/10/10.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AddressInfo : NSObject

@property (nonatomic,copy) NSString *city;
@property (nonatomic,copy) NSString *area;
@property (nonatomic,copy) NSString *address;
@property (nonatomic,copy) NSString *zipCode;

@end

NS_ASSUME_NONNULL_END
