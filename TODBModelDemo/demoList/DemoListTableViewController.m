//
//  DemoListTableViewController.m
//  TODBModel
//
//  Created by Tony on 2017/11/29.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "DemoListTableViewController.h"

#pragma mark - DemoItem
@interface DemoItem : NSObject

@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *className;


+ (instancetype)itemWithName:(NSString *)name className:(NSString *)className;

@end

@implementation DemoItem

+ (instancetype)itemWithName:(NSString *)name className:(NSString *)className{
    DemoItem *item = [[DemoItem alloc] init];
    if (item) {
        item.name = name;
        item.className = className;
    }
    return item;
}
@end


#pragma mark - DemoListTableViewController

@interface DemoListTableViewController ()<
UITableViewDelegate>

@property (nonatomic,strong) NSArray<DemoItem *> *itemList;

@end

@implementation DemoListTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"目录";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuseIdentifier"];
    self.itemList = @[
                      [DemoItem itemWithName:@"通讯录" className:@"AddressBookTableViewController"],
                      [DemoItem itemWithName:@"性能测试" className:@"PreformanceViewController"],
                      ];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.itemList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"reuseIdentifier" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = self.itemList[indexPath.row].name;
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    Class class = NSClassFromString(self.itemList[indexPath.row].className);
    if (class) {
        UIViewController *targetViewController = [[class alloc] init];
        if (targetViewController) {
            [self.navigationController pushViewController:targetViewController animated:YES];
        }
    }
}
@end
