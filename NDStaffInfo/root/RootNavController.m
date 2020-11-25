//
//  RootNavController.m
//  StartMovie
//
//  Created by iMac on 17/5/25.
//  Copyright © 2017年 sinfotek. All rights reserved.
//

#import "RootNavController.h"
#import "UIImage+create.h"
#import "Defines.h"

@interface RootNavController ()

@end

@implementation RootNavController

+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = MainColor;
    [navBar setTranslucent:NO];
    
    [navBar setBackgroundImage:[UIImage imageWithColor:MainColor] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage imageWithColor:MainColor]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
