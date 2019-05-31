//
//  NetWork.h
//  NDStaffInfo
//
//  Created by wangzw on 2019/5/21.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetWork : NSObject

+ (void)getUserInfo:(NSString *)uid
           callBack:(void (^)(BOOL succeed, NSString *msg))callBack;

@end
