//
//  AddressSearchViewController.h
//  TODBModel
//
//  Created by Tony on 17/2/6.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TODBCondition.h"

@interface AddressSearchViewController : UIViewController

@property (nonatomic,strong) void(^searchConditionsBlock)(TODBCondition * conditions);

@end
