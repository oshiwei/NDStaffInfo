//
//  UserInfoHelper.m
//  NDStaffInfo
//
//  Created by wangzw on 2019/11/15.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import "UserInfoHelper.h"
#import "UserInfoModel.h"

@interface UserInfoHelper () <UITableViewDelegate, UITableViewDataSource>
@end

@implementation UserInfoHelper

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.sectionHeaderHeight = 40.f;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
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
    header.contentView.backgroundColor = [UIColor whiteColor];
    [header.textLabel setFont:[UIFont systemFontOfSize:20]];
}

@end
