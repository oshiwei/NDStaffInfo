//
//  UIImage+create.h
//  NDStaffInfo
//
//  Created by wangzw on 2019/11/15.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (create)

+ (UIImage *)imageWithColor:(UIColor *)color;
+ (UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size radius:(NSInteger)radius;

@end
