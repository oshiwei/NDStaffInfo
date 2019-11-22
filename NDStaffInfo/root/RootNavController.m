//
//  RootNavController.m
//  StartMovie
//
//  Created by iMac on 17/5/25.
//  Copyright © 2017年 sinfotek. All rights reserved.
//

#import "RootNavController.h"
#import "UIImage+create.h"

@interface RootNavController ()

@end

@implementation RootNavController

+ (void)initialize {
    UINavigationBar *navBar = [UINavigationBar appearance];
    
    navBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    navBar.tintColor = [UIColor whiteColor];
    navBar.barTintColor = [UIColor colorWithRed:44/255.0 green:185/255.0 blue:176/255.0 alpha:1];
    [navBar setTranslucent:NO];
    
    [navBar setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:44/255.0 green:185/255.0 blue:176/255.0 alpha:1]] forBarMetrics:UIBarMetricsDefault];
    [navBar setShadowImage:[UIImage imageWithColor:[UIColor colorWithRed:44/255.0 green:185/255.0 blue:176/255.0 alpha:1]]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

@end
