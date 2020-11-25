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
                
                NSString *pinYin = @"";
                __block NSString *firstPinYin = @"";
                NSMutableString *mtName = [name mutableCopy];
                if (mtName && CFStringTransform((__bridge CFMutableStringRef)mtName, NULL, kCFStringTransformMandarinLatin, NO)) {
                    if (CFStringTransform((__bridge CFMutableStringRef)mtName, NULL, kCFStringTransformStripDiacritics, NO)) {
                        NSArray *strings = [mtName componentsSeparatedByString:@" "];
                        pinYin = [strings componentsJoinedByString:@""];
                        [strings enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                            if (((NSString *)obj).length > 0) {
                                firstPinYin = [firstPinYin stringByAppendingString:[obj substringToIndex:1]];
                            }
                        }];
                    }
                }
                
                [[DataBaseManager instance] saveUserInfoXMLString:xmlString uid:uid name:name pinyin:pinYin firstpy:firstPinYin];
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

- (void)searchText:(NSString *)text completionHandler:(void (^)(NSArray *info))completionHandler {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSArray *info = [[DataBaseManager instance] searchUser:text];
        dispatch_async(dispatch_get_main_queue(), ^{
            completionHandler(info);
        });
    });
}

@end
