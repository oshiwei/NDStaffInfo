//
//  InfoViewController.m
//  NDStaffInfo
//
//  Created by wangzw on 2019/5/17.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import "InfoViewController.h"
#import "UserInfoManager.h"
#import <Masonry/Masonry.h>
#import "NSDictionary+pretty.h"
#import "UserInfoModel.h"

#ifndef IOS_VERSION
#define IOS_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

#define SEARCH_BAR_HEIGHT  (CGFloat)(IOS_VERSION>=11.0?56.0:44.0)     //搜索栏高度

@interface InfoViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>

@property (nonatomic, strong) NSArray *userInfos;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation InfoViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.userInfos = [NSArray array];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"信息查询";
    
    [self initView];
    [self createTableView];
}

- (void)getUserInfoByUserID:(NSString *)userID{
    
    [[UserInfoManager instance] getUserInfo:userID completionHandler:^(NSDictionary * _Nonnull infoDic) {
        if (!infoDic) {
            return;
        }
        
        NSDictionary *userInfo = [infoDic mutableCopy];
        
        NSDictionary *basic =  userInfo[@"table0"];
        NSDictionary *job =  userInfo[@"table1"];
        NSDictionary *education =  userInfo[@"table2"];
    
        self.userInfos = [UserInfoModel defaultShowUserInfosWithData:@[basic, job, education]];
        NSLog(@"%@", [infoDic jsonPrettyStringEncoded]);
        [self.tableView reloadData];    // 1. 要是tableview还没生产的话，这边就是[nil reloadData]，给nil发消息，什么都不会做。
                                        // 2. self.userInfos已经有值了，所以后面生产的talbleView可以直接使用到数据。
    }];
}

- (void)initView{
    
    self.view = [[UIView alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.view setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 7.0) {
        
        self.automaticallyAdjustsScrollViewInsets = NO;
        self.edgesForExtendedLayout = UIRectEdgeBottom;
    }
}

- (UISearchBar *)searchBar {
    
    if (!_searchBar) {
        UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), SEARCH_BAR_HEIGHT)];
        searchBar.translucent = NO;
        searchBar.clipsToBounds = NO;
        //searchBar.keyboardType = UIKeyboardTypeNumberPad;
        searchBar.placeholder = @"输入工号搜索";

        searchBar.delegate = self;
        _searchBar = searchBar;
    }
    return _searchBar;
}

- (void)createTableView {
    
    [self.view addSubview:self.tableView];
    self.tableView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    UIView *searchBarView = [[UIView alloc] initWithFrame:self.searchBar.frame];
    [searchBarView addSubview:self.searchBar];
    
    self.tableView.tableHeaderView = searchBarView;
}

- (UITableView *)tableView {
    
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.backgroundView = nil;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionFooterHeight = 22.f;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40.0)];
        _tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 40.0)];
        
    }
    return _tableView;
}

#pragma mark Table view method

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.userInfos.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *infos = self.userInfos[section];
    return infos.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"userinfocell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.detailTextLabel.textColor = [UIColor grayColor];
        cell.detailTextLabel.numberOfLines = 0;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    UserInfoModel *userInfo = self.userInfos[indexPath.section][indexPath.row];
    cell.textLabel.text = userInfo.title;
    cell.detailTextLabel.text = userInfo.value;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *sectionTitle = @"";
    switch (section) {
        case 0:
            sectionTitle = @"基本资料";
            break;
        case 1:
            sectionTitle = @"在职信息";
            break;
        case 2:
            sectionTitle = @"教育经历";
            break;
        default:
            break;
    }
    
    return sectionTitle;
}

- (void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section {
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.contentView.backgroundColor= [UIColor whiteColor];
    [header.textLabel setFont:[UIFont systemFontOfSize:20]];
}


#pragma mark - UISearchBarDelegate
- (BOOL)searchBar:(UISearchBar *)searchBar shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    return YES;
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {

    [searchBar setShowsCancelButton:YES animated:YES];
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar {
    [searchBar setShowsCancelButton:NO animated:YES];
    return YES;
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self getUserInfoByUserID:searchBar.text];
    [searchBar resignFirstResponder];
    
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
}

@end

