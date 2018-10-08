//
//  EditAddressViewController.m
//  TODBModel
//
//  Created by Tony on 17/2/6.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "EditAddressViewController.h"

@interface EditAddressViewController ()

@property (nonatomic,strong) IBOutlet UILabel *idLabel;
@property (nonatomic,strong) IBOutlet UITextField *nameTextField;
@property (nonatomic,strong) IBOutlet UITextField *mobileTextField;
@property (nonatomic,strong) IBOutlet UITextView *adddressTextView;
@property (nonatomic,strong) IBOutlet UILabel *editTimeLabel;

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self setEdgesForExtendedLayout:UIRectEdgeNone];

    self.model = self.model;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStylePlain target:self action:@selector(saveHandler:)];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Events
- (void)saveHandler:(id)sender{
    if (!_model) {
        _model = [AddressModel crateModel];
    }
    self.model.userinfo.name = self.nameTextField.text;
    self.model.mobile = self.mobileTextField.text;
    self.model.address = self.adddressTextView.text;
    self.model.editDate = [NSDate date];
    
    [self.model save:^(NSObject *model) {
        
    }];
    [self.navigationController popViewControllerAnimated:YES];

}

#pragma mark - Setter
- (void)setModel:(AddressModel *)model{
    _model = model;
    if (self.viewLoaded) {
        self.nameTextField.text = model.userinfo.name;
        self.mobileTextField.text = model.mobile;
        self.adddressTextView.text = model.address;
        self.idLabel.text = [NSString stringWithFormat:@"ID:%d",model.addressID];
        self.editTimeLabel.text = [[[self class] formatter] stringFromDate:model.editDate];
    }
}

+ (NSDateFormatter *)formatter{
    static NSDateFormatter *formatter;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"修改时间：YYYY-MM-DD HH:mm:ss";
    });
    return formatter;
}

@end
