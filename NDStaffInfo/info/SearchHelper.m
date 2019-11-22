//
//  SearchHelper.m
//  NDStaffInfo
//
//  Created by wangzw on 2019/11/22.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import "SearchHelper.h"
#import "UIImage+create.h"
#import "Defines.h"

@interface SearchHelper () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
@end

@implementation SearchHelper

+ (void)initialize {
    if (@available(iOS 9.0, *)) {
        [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];
    }else {
        [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
    }
}

- (UISearchBar *)searchBar {
    if (!_searchBar) {
        _searchBar = [[UISearchBar alloc] init];
        _searchBar.placeholder = @"请输入用户工号或用户名";
        _searchBar.delegate = self;
        
        UIImage *image = [UIImage imageWithColor:[UIColor whiteColor]];
        image = [UIImage createRoundedRectImage:image size:CGSizeMake(kScreenWidth, 34) radius:17];
        [_searchBar setSearchFieldBackgroundImage:image forState:UIControlStateNormal];
        
        //修改取消按钮颜色，需要将输入提示颜色改回
        _searchBar.tintColor = [UIColor whiteColor];
        if (@available(iOS 13.0, *)) {
            //要适配iOS13
        } else {
            UITextField *seachField = [_searchBar valueForKey:@"searchField"];
            seachField.tintColor = [UIColor blackColor];
        }
    }
    return _searchBar;
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
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil;
}


- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

#pragma mark Table view method

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 40;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"searchresultcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

@end
