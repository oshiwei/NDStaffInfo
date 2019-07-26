//
//  NSDictionary+pretty.m
//  NDStaffInfo
//
//  Created by Linhz on 2019/7/24.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import "NSDictionary+pretty.h"

@implementation NSDictionary (pretty)

- (NSString *)jsonPrettyStringEncoded {
    
    if ([NSJSONSerialization isValidJSONObject:self]) {
        NSError *error;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self options:NSJSONWritingPrettyPrinted error:&error];
        NSString *json = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        if (!error) return json;
    }
    return nil;
}

@end
