//
//  CreateAddressHelper.m
//  TODBModel
//
//  Created by TonyJR on 2018/10/8.
//  Copyright © 2018年 Tony. All rights reserved.
//

#import "CreateAddressHelper.h"

#define MOBILE_HEAD @[@"130",@"131",@"132",@"133",@"134",@"135",@"136",@"137",@"138",@"139"];
#define SURNAME @[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"冯",@"陈",@"楮",@"蒋",@"沈",@"韩",@"杨",@"朱",@"秦",@"尤",@"许",@"何",@"吕",@"施",@"张",@"孔",@"曹",@"严",@"华",@"卫"];
#define CN_NUM @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];

@implementation CreateAddressHelper

+ (NSArray<AddressModel *> *)createAddress:(NSUInteger)count
{
    NSDate *date = [NSDate date];
    
    NSArray *createdModels = [AddressModel crateModels:count];
    NSArray *createdUserinfo = [Userinfo crateModels:count];
    
    NSLog(@"创建%ld条记录用时%f",count,[[NSDate date] timeIntervalSinceDate:date]);
    date = [NSDate date];
    NSArray *mobileHead = MOBILE_HEAD;
    NSArray *surname = SURNAME;
    
    NSArray *cnNumber = CN_NUM;
    date = [NSDate date];
    for (int i=0; i<count ;i++) {
        AddressModel *model = createdModels[i];
        Userinfo *userinfo = createdUserinfo[i];
        
        model.editDate = [NSDate date];
        userinfo.name = [NSString stringWithFormat:@"%@%@%@",surname[model.addressID%surname.count],cnNumber[model.addressID%100/10],cnNumber[model.addressID%10]];
        model.userinfo = userinfo;
        model.mobile = [NSString stringWithFormat:@"%@%08d",mobileHead[rand()%mobileHead.count],model.addressID];
        [model save:nil];
    }
    NSLog(@"更新%ld条记录用时%f",count,[[NSDate date] timeIntervalSinceDate:date]);
    
    return createdModels;
}

@end
