//
//  SearchViewController.m
//  NDStaffInfo
//
//  Created by 王志伟 on 2020/11/25.
//  Copyright © 2020 sinfotek. All rights reserved.
//

#import "SearchViewController.h"
#import <Masonry/Masonry.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "UIImage+create.h"
#import "Defines.h"
#import "UserInfoManager.h"
#import "UserInfoModel.h"
#import "InfoViewController.h"
#import "SearchTipView.h"

@interface SearchViewController () <UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray *searchResults;
@property (nonatomic, strong) SearchTipView *tipView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    {
        if (@available(iOS 9.0, *)) {
            [[UIBarButtonItem appearanceWhenContainedInInstancesOfClasses:@[[UISearchBar class]]] setTitle:@"取消"];
        } else {
            [[UIBarButtonItem appearanceWhenContainedIn:[UISearchBar class], nil] setTitle:@"取消"];
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
        if (@available(iOS 11.0, *)) {
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    self.title = @"信息查询";
    
    [self createUI];
    [self refreshTipView];
}

- (void)createUI {
    self.tableView.tableHeaderView = self.searchBar;
    self.tableView.tableFooterView = [UIView new]; // 去除无数据时的线条
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.searchBar sizeToFit];
    self.searchBar.barTintColor = self.navigationController.navigationBar.barTintColor;
    [self.searchBar setBackgroundImage:[UIImage imageWithColor:self.navigationController.navigationBar.barTintColor]];
    
    [self.tableView addSubview:self.tipView];
    [self.tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.tableView);
    }];
}

#pragma mark - getter

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

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.backgroundView = [UIView new];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    }
    return _tableView;
}

- (SearchTipView *)tipView {
    if (!_tipView) {
        _tipView = [SearchTipView new];
        __weak __typeof(self)weakSelf = self;
        _tipView.searchClickBlock = ^{
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            NSString *search = [strongSelf.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
            [strongSelf getUserInfoByUserID:search];
        };
    }
    return _tipView;
}

#pragma mark - setter

- (void)setSearchResults:(NSArray *)searchResults {
    _searchResults = searchResults;
    
    [self.tableView reloadData];
    [self refreshTipView];
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
    [self searchText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    searchBar.text = nil;
    self.searchResults = nil;
}

#pragma mark - UITableViewDelegate & UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *identifier = @"searchresultcell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.textColor = [UIColor blackColor];
    }
    UserInfoModel *info = self.searchResults[indexPath.row];
    NSString *title = info.title.length > 0 ? info.title : @"";
    title = [title stringByAppendingFormat:@"(%@)", info.value.length > 0 ? info.value : @""];
    cell.textLabel.text = title;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    UserInfoModel *info = self.searchResults[indexPath.row];
    [self getUserInfoByUserID:info.value];
}

#pragma mark - action

- (BOOL)isUid:(NSString *)string {
    NSString *regex = @"^\\d{3,8}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return [pred evaluateWithObject:string];
}

- (void)refreshTipView {
    if (self.searchResults.count == 0) {
        self.tipView.hidden = NO;
        NSString *search = [self.searchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        if (search.length == 0) {
            self.tipView.label.text = @"没有数据";
            self.tipView.subLabel.text = @"请输入查找内容";
            [self.tipView showSearchButton:NO];
        } else {
            self.tipView.label.text = @"未找到用户";
            if ([self isUid:search]) {
                self.tipView.subLabel.text = [NSString stringWithFormat:@"点击“搜索”按钮，线上查询工号:%@", search];
                [self.tipView showSearchButton:YES];
            } else {
                self.tipView.subLabel.text = @"试试输入用户工号，线上查询";
                [self.tipView showSearchButton:NO];
            }
        }
    } else {
        self.tipView.hidden = YES;
    }
}

- (void)searchText:(NSString *)text {
    NSString *search = [text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if (search.length == 0) {
        self.searchResults = nil;
        return;
    }
    [[UserInfoManager instance] searchText:search completionHandler:^(NSArray * _Nonnull info) {
        self.searchResults = info;
    }];
}

- (void)getUserInfoByUserID:(NSString *)userID {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [[UserInfoManager instance] getUserInfo:userID completionHandler:^(NSDictionary * _Nonnull infoDic) {
        if (!infoDic) {
            hud.label.text = @"未查询到数据";
            hud.mode = MBProgressHUDModeText;
            [hud hideAnimated:YES afterDelay:2];
            return;
        }
        [hud hideAnimated:YES];

        NSDictionary *userInfo = [infoDic mutableCopy];

        NSDictionary *basic =  userInfo[@"table0"];
        NSDictionary *job =  userInfo[@"table1"];
        NSDictionary *education =  userInfo[@"table2"];

        NSArray *userInfos = [UserInfoModel defaultShowUserInfosWithData:@[basic?:@{}, job?:@{}, education?:@{}]];
        InfoViewController *info = [InfoViewController new];
        info.userInfos = userInfos;
        [self.navigationController pushViewController:info animated:YES];
    }];
}

@end
