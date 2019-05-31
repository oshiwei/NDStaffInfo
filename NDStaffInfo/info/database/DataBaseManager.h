//
//  DataBaseManager.h
//  NDStaffInfo
//
//  Created by wangzw on 2019/5/17.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FMDB/FMDB.h>

NS_ASSUME_NONNULL_BEGIN

@interface DataBaseManager : NSObject

+ (DataBaseManager *)instance;

- (BOOL)userInfoIsExist:(NSString *)uid;
- (NSString *)getUserInfoXMLString:(NSString *)uid;
- (BOOL)saveUserInfoXMLString:(NSString *)xmlString uid:(NSString *)uid name:(NSString *)name;

- (NSArray *)getUserInfoXMLStirngByName:(NSString *)name;

@end

NS_ASSUME_NONNULL_END
