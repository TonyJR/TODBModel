//
//  ViewController.m
//  TODBModel
//
//  Created by Tony on 16/11/22.
//  Copyright © 2016年 Tony. All rights reserved.
//

#import "ViewController.h"
#import "TestModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    TestModel *testModel;
    
    NSDate *date = [NSDate date];
    testModel = [TestModel modelByKey:@"102"];
    
    NSLog(@"%@",testModel);
    testModel = [TestModel modelByKey:@"102"];
    
    NSLog(@"%@",testModel);
    NSLog(@"搜索用时%f",[[NSDate date] timeIntervalSinceDate:date]);

    
    
    [self.imageView setImage:testModel.image];
    NSLog(@"---%@",testModel.model.name);
    testModel.test = [NSDate date];
    testModel.name = @"123";

    
    [self.imageView setImage:testModel.image];

    testModel.image = [UIImage imageNamed:@"user"];
    
    TestModel *testModel2;
    testModel2 = [TestModel modelByKey:@"103"];
    testModel2.name = @"103";

    testModel.model = testModel2;
    
    [testModel2 save];
    [testModel save];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
