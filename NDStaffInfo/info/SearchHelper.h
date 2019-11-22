//
//  SearchHelper.h
//  NDStaffInfo
//
//  Created by wangzw on 2019/11/22.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchHelper : NSObject

@property (nonatomic, strong) UISearchBar *searchBar;

@property (nonatomic, strong) NSArray *searchResults;
@property (nonatomic, strong) UITableView *tableView;

@end
