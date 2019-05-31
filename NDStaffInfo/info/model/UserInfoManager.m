//
//  UserInfoManager.m
//  NDStaffInfo
//
//  Created by wangzw on 2019/5/21.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import "UserInfoManager.h"
#import "DataBaseManager.h"
#import "NetWork.h"
#import <Ono/Ono.h>

@implementation UserInfoManager

+ (UserInfoManager *)instance {
    static UserInfoManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[super allocWithZone:NULL] init];
    });
    return instance;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [self instance];
}

// NSCopying
- (id)copyWithZone:(nullable NSZone *)zone {
    return self;
}

- (void)processXMLString:(NSString *)uid
       userInfoXMLString:(NSString *)userInfoXMLString
                  saveDB:(BOOL)saveDB
       completionHandler:(void (^)(NSDictionary *infoDic))completionHandler {
    NSDictionary *infoDic = nil;
    NSRange range = [userInfoXMLString rangeOfString:@"<root>[\\w\\W]*</root>" options:NSRegularExpressionSearch];
    if (range.location != NSNotFound) {
        NSString *xmlString = [userInfoXMLString substringWithRange:range];
        NSError *error = nil;
        ONOXMLDocument *document = [ONOXMLDocument XMLDocumentWithString:xmlString encoding:NSUTF8StringEncoding error:&error];
        if (document && !error && document.rootElement.children.count > 0) {
            NSMutableDictionary *mtDic = [NSMutableDictionary dictionary];
            for (ONOXMLElement *telement in document.rootElement.children) {
                NSMutableDictionary *mtSubDic = [NSMutableDictionary dictionary];
                for (ONOXMLElement *element in telement.children) {
                    [mtSubDic setObject:element.stringValue forKey:element.tag];
                }
                [mtDic setObject:[mtSubDic copy] forKey:telement.tag];
            }
            infoDic = [mtDic copy];
            if (saveDB) {
                NSString *name = infoDic[@"table0"][@"txt_spersonname_a5_cwperson"];
                [[DataBaseManager instance] saveUserInfoXMLString:userInfoXMLString uid:uid name:name];
            }
        }
    }
    if (completionHandler) {
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(infoDic);
        });
    }
}

- (void)getUserInfo:(NSString *)uid completionHandler:(void (^)(NSDictionary *infoDic))completionHandler {
    if (!uid || [uid length] == 0) {
        completionHandler(nil);
        return;
    }
    
    NSString *userInfoXMLString = [[DataBaseManager instance] getUserInfoXMLString:uid];
    if (!userInfoXMLString) {
        [NetWork getUserInfo:uid callBack:^(BOOL succeed, NSString *msg) {
            if (succeed && msg.length > 0) {
                [self processXMLString:uid userInfoXMLString:msg saveDB:YES completionHandler:completionHandler];
            }
        }];
    } else {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
           [self processXMLString:uid userInfoXMLString:userInfoXMLString saveDB:NO completionHandler:completionHandler];
        });
    }
}

- (void)updateUserInfoCache {
    //控制最多同时存在5个请求
    dispatch_semaphore_t semaphore = dispatch_semaphore_create(5);
    
    NSInteger uid = 100;
    while (uid <= 999999) {
        if (![[DataBaseManager instance] userInfoIsExist:@(uid).stringValue]) {
            dispatch_semaphore_wait(semaphore, DISPATCH_TIME_FOREVER);
            [NetWork getUserInfo:@(uid).stringValue callBack:^(BOOL succeed, NSString *msg) {
                dispatch_semaphore_signal(semaphore);
                
                
            }];
        }
    }
}

@end
