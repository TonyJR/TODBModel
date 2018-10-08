//
//  Userinfo.h
//  TODBModel
//
//  Created by TonyJR on 2018/10/8.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    UserSexUnknow,
    UserSexMale,
    UserSexFemale,
} UserSex;

@interface Userinfo : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,assign) UserSex sex;
@property (nonatomic,assign) int infoID;


@end

NS_ASSUME_NONNULL_END
