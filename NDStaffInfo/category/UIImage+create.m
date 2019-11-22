//
//  UIImage+create.m
//  NDStaffInfo
//
//  Created by wangzw on 2019/11/15.
//  Copyright © 2019 sinfotek. All rights reserved.
//

#import "UIImage+create.h"

@implementation UIImage (create)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return theImage;
}

static void addRoundedRectToPath(CGContextRef context, CGRect rect,float ovalWidth, float ovalHeight) {
    float fw, fh;
    if (ovalWidth == 0 || ovalHeight ==0 ) {
        CGContextAddRect(context, rect);
        return;
    }
    CGContextSaveGState(context);
    CGContextTranslateCTM(context, CGRectGetMinX(rect), CGRectGetMinY(rect));
    CGContextScaleCTM(context, ovalWidth, ovalHeight);
    fw = CGRectGetWidth(rect) / ovalWidth;
    fh = CGRectGetHeight(rect) / ovalHeight;
    CGContextMoveToPoint(context, fw, fh/2);                // Start at lower right corner
    CGContextAddArcToPoint(context, fw, fh, fw/2, fh,1);    // Top right corner
    CGContextAddArcToPoint(context,0, fh,0, fh/2,1);        // Top left corner
    CGContextAddArcToPoint(context,0,0, fw/2,0,1);          // Lower left corner
    CGContextAddArcToPoint(context, fw,0, fw, fh/2,1);      // Back to lower right
    CGContextClosePath(context);
    CGContextRestoreGState(context);
}

+ (UIImage *)createRoundedRectImage:(UIImage *)image size:(CGSize)size radius:(NSInteger)radius {
    // the size of CGContextRef
    int w = size.width;
    int h = size.height;
    
    UIImage *img = image;
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, w, h, 8, 4 * w, colorSpace, kCGImageAlphaPremultipliedFirst);
    CGRect rect = CGRectMake(0,0, w, h);
    CGContextBeginPath(context);
    addRoundedRectToPath(context, rect, radius, radius);
    CGContextClosePath(context);
    CGContextClip(context);
    CGContextDrawImage(context, CGRectMake(0, 0, w, h), img.CGImage);
    CGImageRef imageMasked = CGBitmapContextCreateImage(context);
    img = [UIImage imageWithCGImage:imageMasked];
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    CGImageRelease(imageMasked);
    return img;
}

@end
