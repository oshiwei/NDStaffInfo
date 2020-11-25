//
//  SearchTipView.m
//  NDStaffInfo
//
//  Created by 王志伟 on 2020/11/25.
//  Copyright © 2020 sinfotek. All rights reserved.
//

#import "SearchTipView.h"
#import "UIImage+create.h"
#import "Defines.h"
#import <Masonry/Masonry.h>

@interface SearchTipView ()
@property (nonatomic, strong) MASConstraint *bottom;
@end

@implementation SearchTipView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initilezeSubview];
    }
    return self;
}

- (void)initilezeSubview {
    [self addSubview:self.label];
    [self addSubview:self.subLabel];
    [self addSubview:self.searchButton];
    
    [self.label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        make.width.greaterThanOrEqualTo(@100);
    }];
    [self.subLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.label.mas_bottom).offset(10);
        make.left.equalTo(self).offset(10);
        make.right.equalTo(self).offset(-10);
        
        self.bottom = make.bottom.equalTo(self).offset(-10);
    }];
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(-10);
        make.centerX.equalTo(self);
    }];
    
    [self showSearchButton:NO];
}

- (void)searchClick {
    if (self.searchClickBlock) {
        self.searchClickBlock();
    }
}

- (void)showSearchButton:(BOOL)show {
    self.searchButton.hidden = !show;
    self.bottom.offset = show ? -60 : -10;
}

#pragma mark - getter

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        _label.textColor = [UIColor blackColor];
        _label.textAlignment = NSTextAlignmentCenter;
    }
    return _label;
}

- (UILabel *)subLabel {
    if (!_subLabel) {
        _subLabel = [UILabel new];
        _subLabel.textColor = [UIColor grayColor];
        _subLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _subLabel;
}

- (UIButton *)searchButton {
    if (!_searchButton) {
        _searchButton = [UIButton new];
        UIImage *backImage = [UIImage createRoundedRectImage:[UIImage imageWithColor:MainColor]
                                                        size:CGSizeMake(100, 40) radius:20];
        [_searchButton setBackgroundImage:backImage forState:UIControlStateNormal];
        [_searchButton setTitle:@"搜索" forState:UIControlStateNormal];
        [_searchButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_searchButton addTarget:self action:@selector(searchClick) forControlEvents:UIControlEventTouchUpInside];
    }
    return _searchButton;
}

@end
