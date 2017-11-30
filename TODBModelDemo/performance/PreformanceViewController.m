//
//  PreformanceViewController.m
//  TODBModel
//
//  Created by Tony on 2017/11/29.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "PreformanceViewController.h"
#import "AddressModel.h"
#import "NSObject+Search.h"

@interface PreformanceViewController ()

@property (nonatomic,strong) IBOutlet UITextField *createCountText;
@property (nonatomic,strong) IBOutlet UIButton *searchKeyButton;
@property (nonatomic,strong) IBOutlet UIButton *searchTypeButton;
@property (nonatomic,strong) IBOutlet UITextField *searchValueText;


@property (nonatomic,strong) IBOutlet UITextView *logTextView;

@end

@implementation PreformanceViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
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

- (void)log:(NSString *)logStr{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.logTextView.text = [self.logTextView.text stringByAppendingFormat:@"\n%@",logStr];
        CGFloat top = self.logTextView.contentSize.height - self.logTextView.frame.size.height;
        top = MAX(top, 0);
        [self.logTextView scrollRectToVisible:CGRectMake(0, top, 0, 0) animated:YES];
    });
}

- (IBAction)endEdit:(id)sender{
    [self.view endEditing:YES];
}

- (IBAction)insert:(id)sender{
    NSInteger count = [self.createCountText.text integerValue];
    if (count > 0) {
        NSDate *date = [NSDate date];
        NSArray *createdModels = [AddressModel crateModels:count];
        [self log:[NSString stringWithFormat:@"创建%ld条记录用时%f",count,[[NSDate date] timeIntervalSinceDate:date]]];
    }
    [self endEdit:nil];
}

- (IBAction)search:(id)sender{
    
}

- (IBAction)findAll:(id)sender{
    NSArray *createdModels = [AddressModel allModels];
}

- (IBAction)removeAll:(id)sender{
    
}

- (IBAction)clearLog:(id)sender{
    
}

@end
