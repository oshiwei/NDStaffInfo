//
//  NetWork.m
//  NDStaffInfo
//
//  Created by wangzw on 2019/5/21.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import "NetWork.h"
#import <AFNetworking/AFNetworking.h>

@implementation NetWork

+ (AFHTTPSessionManager *)manager {
    static AFHTTPSessionManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [AFHTTPSessionManager manager];
        //返回在并行队列中执行
        manager.completionQueue = dispatch_queue_create("net.callback.concurrentqueue", DISPATCH_QUEUE_CONCURRENT);
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"getValueForControls" forHTTPHeaderField:@"X-AjaxPro-Method"];
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", nil];
    });
    return manager;
}

+ (void)getUserInfo:(NSString *)uid callBack:(void (^)(BOOL succeed, NSString *msg))callBack {
    // 这边要检查uid是否合法，不能输了lhz也去请求
    
    NSString *urlStr = @"http://nderp.99.com/ajaxpro/Nd.Hr.Webs.Rsdaweb.K7_frmrsdaUserInfo,Nd.Hr.Webs.ashx";
    NSDictionary *param = @{@"spersoncode":uid};
    [[self manager] POST:urlStr
              parameters:param
                progress:nil
                 success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                     
        NSString *responseString = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        callBack(YES, responseString);
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        callBack(NO, @"请求失败");
    }];
}

@end
