//
//  AddressTableViewCell.m
//  TODBModel
//
//  Created by Tony on 17/2/5.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell()

@property (nonatomic,strong) IBOutlet UILabel *nameLabel;
@property (nonatomic,strong) IBOutlet UILabel *editDateLabel;
@property (nonatomic,strong) IBOutlet UILabel *mobileLabel;

@end

@implementation AddressTableViewCell

+ (NSDateFormatter *)formatter{
    static NSDateFormatter *formatter;

    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"修改时间：YYYY-MM-DD HH:mm:ss";
    });
    return formatter;
}


- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAddressModel:(AddressModel *)addressModel{
    _addressModel = addressModel;
    self.nameLabel.text = addressModel.userinfo.name;
    self.editDateLabel.text = [[[self class] formatter] stringFromDate:addressModel.editDate];
    self.mobileLabel.text = addressModel.mobile;
}

@end
