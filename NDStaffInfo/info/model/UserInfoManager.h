//
//  UserInfoManager.h
//  NDStaffInfo
//
//  Created by wangzw on 2019/5/21.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface UserInfoManager : NSObject

+ (UserInfoManager *)instance;

- (void)getUserInfo:(NSString *)uid completionHandler:(void (^)(NSDictionary *infoDic))completionHandler;

@end

NS_ASSUME_NONNULL_END
