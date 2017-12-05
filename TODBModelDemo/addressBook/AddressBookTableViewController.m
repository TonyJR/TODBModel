//
//  AddressBookTableViewController.m
//  TODBModel
//
//  Created by Tony on 17/2/5.
//  Copyright © 2017年 Tony. All rights reserved.
//

#import "AddressBookTableViewController.h"
#import "AddressModel.h"
#import "AddressTableViewCell.h"
#import "AddressSearchViewController.h"
#import "TODBOrCondition.h"
#import "EditAddressViewController.h"

#import "NSObject+TODBModel.h"
#import "NSObject+Cache.h"
#import "NSObject+Search.h"

#define MOBILE_HEAD @[@"130",@"131",@"132",@"133",@"134",@"135",@"136",@"137",@"138",@"139"];
#define SURNAME @[@"赵",@"钱",@"孙",@"李",@"周",@"吴",@"郑",@"王",@"冯",@"陈",@"楮",@"蒋",@"沈",@"韩",@"杨",@"朱",@"秦",@"尤",@"许",@"何",@"吕",@"施",@"张",@"孔",@"曹",@"严",@"华",@"卫"];
#define CN_NUM @[@"零",@"一",@"二",@"三",@"四",@"五",@"六",@"七",@"八",@"九"];

#define kAddressCellTag @"AddressCellTag"


@interface AddressBookTableViewController ()<UISearchBarDelegate>
{
    
}
@property (nonatomic,strong) NSMutableArray *dataList;

@property (nonatomic,strong) UISearchBar *searchBar;

@end


@implementation AddressBookTableViewController

#pragma mark - Life Cycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    [self initUI];
    
    [self loadModels];
}

- (void)initUI{
    self.title = @"通讯录";
    self.navigationItem.rightBarButtonItems = @[
                                                
                                                [[UIBarButtonItem alloc] initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(leftBarButtonClickHandler:)],
                                                [[UIBarButtonItem alloc] initWithTitle:@"添加" style:UIBarButtonItemStylePlain target:self action:@selector(rightBarButtonClickHandler:)],
                                                ];
    
    
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.tableView registerNib:[UINib nibWithNibName:@"AddressTableViewCell" bundle:nil] forCellReuseIdentifier:kAddressCellTag];
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    self.tableView.estimatedRowHeight = 60;
}

- (void)loadModels{
    __weak id self_weak = self;
    [AddressModel allModels:^(NSArray<NSObject *> *models) {
        __strong AddressBookTableViewController *self_strong = self_weak;

        self_strong.dataList = [NSMutableArray arrayWithArray:models];
        if (self_strong.dataList.count == 0) {
            self_strong.dataList = [NSMutableArray arrayWithArray:[self createAddress:1000]];
        }
        [self_strong.tableView reloadData];
    }];
}

- (NSArray *)createAddress:(NSUInteger)count
{
    NSDate *date = [NSDate date];
    
    
    NSArray *createdModels = [AddressModel crateModels:count];

    NSLog(@"创建%ld条记录用时%f",count,[[NSDate date] timeIntervalSinceDate:date]);
    date = [NSDate date];
    NSArray *mobileHead = MOBILE_HEAD;
    NSArray *surname = SURNAME;

    NSArray *cnNumber = CN_NUM;
    date = [NSDate date];
    for (AddressModel *model in createdModels) {
        model.editDate = [NSDate date];
        
        model.name = [NSString stringWithFormat:@"%@%@%@",surname[model.addressID%surname.count],cnNumber[model.addressID%100/10],cnNumber[model.addressID%10]];
        model.mobile = [NSString stringWithFormat:@"%@%08d",mobileHead[rand()%mobileHead.count],model.addressID];
        [model save:nil];
    }
    NSLog(@"更新%ld条记录用时%f",count,[[NSDate date] timeIntervalSinceDate:date]);

    return createdModels;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Getter
- (UISearchBar *)searchBar{
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, [ UIScreen mainScreen ].bounds.size.width, 46)];
        _searchBar.delegate = self;
    }
    return _searchBar;
}

#pragma mark - Events
- (void)leftBarButtonClickHandler:(UIBarButtonItem *)sender{
    if (self.tableView.isEditing) {
        sender.title = @"编辑";
        [self.tableView setEditing:NO animated:YES];
    }else{
        sender.title = @"完成";
        [self.tableView setEditing:YES animated:YES];
    }
}

- (void)rightBarButtonClickHandler:(id)sender{
    if (self.tableView.isEditing) {
        [self leftBarButtonClickHandler:self.navigationItem.leftBarButtonItem];
    }
    
    EditAddressViewController *editer = [[EditAddressViewController alloc] init];
    
    [self.navigationController pushViewController:editer animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataList.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    AddressTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kAddressCellTag forIndexPath:indexPath];
    
    cell.addressModel = self.dataList[indexPath.row];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        AddressModel *addressModel = self.dataList[indexPath.row];
        [addressModel del:nil];
        [self.dataList removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EditAddressViewController *editer = [[EditAddressViewController alloc] init];
    editer.model = self.dataList[indexPath.row];
    [self.navigationController pushViewController:editer animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark <UISearchBarDelegate>
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    

    if (searchText.length > 0) {
        __weak id self_weak = self;
        
        TODBCondition *condition1 = [TODBCondition condition:@"name" like:[NSString stringWithFormat:@"%%%@%%",searchText]];
        TODBCondition *condition2 = [TODBCondition condition:@"mobile" like:[NSString stringWithFormat:@"%%%@%%",searchText]];
        [AddressModel search:[TODBOrCondition conditionWith:condition1 or:condition2] callBack:^(NSArray<NSObject *> *models) {
            __strong AddressBookTableViewController *self_strong = self_weak;
            self_strong.dataList = [NSMutableArray arrayWithArray:models];
            [self_strong.tableView reloadData];

        }];
        
    }else{
        [self loadModels];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar endEditing:YES];
}

@end
