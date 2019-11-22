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
#import "SearchHelper.h"
#import "UserInfoHelper.h"
#import "UserInfoModel.h"
#import "UIImage+create.h"

@interface InfoViewController ()
@property (nonatomic, strong) SearchHelper *searchHelper;
@property (nonatomic, strong) UserInfoHelper *userInfoHelper;
@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    {
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (@available(iOS 11.0, *)) {
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"信息查询";
    
    self.searchHelper = [SearchHelper new];
    self.userInfoHelper = [UserInfoHelper new];
    
    [self.view addSubview:self.searchHelper.tableView];
    [self.searchHelper.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self.searchHelper.searchBar sizeToFit];
    self.searchHelper.searchBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    [self.searchHelper.searchBar setBackgroundImage:[UIImage imageWithColor:self.navigationController.navigationBar.barTintColor]];
    
    [self.view addSubview:self.userInfoHelper.tableView];
    [self.userInfoHelper.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left);
        make.bottom.equalTo(self.view.mas_bottom);
        make.right.equalTo(self.view.mas_right);
    }];
    
    [self showSearchMode:YES];
     
//    [self getUserInfoByUserID:@"158008"];
}

- (void)showSearchMode:(BOOL)search {
    self.searchHelper.tableView.hidden = !search;
    self.userInfoHelper.tableView.hidden = search;
    if (search) {
        self.searchHelper.tableView.tableHeaderView = self.searchHelper.searchBar;
    } else {
        self.userInfoHelper.tableView.tableHeaderView = self.searchHelper.searchBar;
    }
}

#pragma netwroking

- (void)getUserInfoByUserID:(NSString *)userID {
    [[UserInfoManager instance] getUserInfo:userID completionHandler:^(NSDictionary * _Nonnull infoDic) {
        if (!infoDic) {
            return;
        }
        
        NSDictionary *userInfo = [infoDic mutableCopy];
        
        NSDictionary *basic =  userInfo[@"table0"];
        NSDictionary *job =  userInfo[@"table1"];
        NSDictionary *education =  userInfo[@"table2"];
        
        self.userInfoHelper.userInfos = [UserInfoModel defaultShowUserInfosWithData:@[basic, job, education]];
        NSLog(@"%@", [infoDic jsonPrettyStringEncoded]);
        [self.userInfoHelper.tableView reloadData];
    }];
}

@end

