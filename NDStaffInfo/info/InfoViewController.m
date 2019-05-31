//
//  InfoViewController.m
//  NDStaffInfo
//
//  Created by wangzw on 2019/5/17.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import "InfoViewController.h"
#import "UserInfoManager.h"

@interface InfoViewController ()

@end

@implementation InfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = @"信息查询";
    
    [[UserInfoManager instance] getUserInfo:@"" completionHandler:^(NSDictionary * _Nonnull infoDic) {
    }];
}

@end
