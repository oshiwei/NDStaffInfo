//
//  SearchTipView.h
//  NDStaffInfo
//
//  Created by 王志伟 on 2020/11/25.
//  Copyright © 2020 sinfotek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTipView : UIView

@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *subLabel;
@property (nonatomic, strong) UIButton *searchButton;

@property (nonatomic, copy) void (^searchClickBlock)(void);
- (void)showSearchButton:(BOOL)show;

@end
