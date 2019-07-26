//
//  UserInfoModel.h
//  NDStaffInfo
//
//  Created by Linhz on 2019/7/25.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoModel : NSObject

@property (nonatomic, copy) NSString *title;

@property (nonatomic, copy) NSString *value;

+ (UserInfoModel *)userInfoWithKey:(NSString *)key value:(NSString *)value;

+ (NSArray *)defaultShowUserInfosWithData:(NSArray *)data;

@end

NS_ASSUME_NONNULL_END
