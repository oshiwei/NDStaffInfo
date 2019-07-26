//
//  WSMovieController.m
//  StartMovie
//
//  Created by iMac on 16/8/29.
//  Copyright © 2016年 sinfotek. All rights reserved.
//

#import "WSMovieController.h"
#import <AVFoundation/AVFoundation.h>
#import <AVKit/AVKit.h>
#import "RootNavController.h"
#import "InfoViewController.h"

@interface WSMovieController ()
@property (strong, nonatomic) AVPlayerViewController *playerC;
@end

@implementation WSMovieController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self SetupVideoPlayer];
}


- (void)SetupVideoPlayer
{
    AVPlayer *player = [AVPlayer playerWithURL:self.movieURL];
    self.playerC = [[AVPlayerViewController alloc] init];
    self.playerC.player = player;
    self.playerC.videoGravity = AVLayerVideoGravityResizeAspectFill;
    self.playerC.showsPlaybackControls = NO;
    [self addChildViewController:self.playerC];
    [self.view addSubview:self.playerC.view];
    [self.playerC.view setFrame:[UIScreen mainScreen].bounds];
    self.playerC.view.alpha = 0;
    [UIView animateWithDuration:3 animations:^{
        self.playerC.view.alpha = 1;
    } completion:^(BOOL finished) {
        [self.playerC.player play];
    }];
    
    [self setupLoginView];
}

- (void)setupLoginView
{
    //进入按钮
    UIButton *enterMainButton = [[UIButton alloc] init];
    enterMainButton.frame = CGRectMake(24, [UIScreen mainScreen].bounds.size.height - 32 - 48, [UIScreen mainScreen].bounds.size.width - 48, 48);
    enterMainButton.layer.borderWidth = 1;
    enterMainButton.layer.cornerRadius = 24;
    enterMainButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [enterMainButton setTitle:@"进入应用" forState:UIControlStateNormal];
    enterMainButton.alpha = 0;
    [self.view addSubview:enterMainButton];
    [enterMainButton addTarget:self action:@selector(enterMainAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [UIView animateWithDuration:3.0 animations:^{
        enterMainButton.alpha = 1.0;
    }];
}

- (void)enterMainAction:(UIButton *)btn {
    NSLog(@"进入应用");
    RootNavController *rootTabCtrl = [[RootNavController alloc] initWithRootViewController:[InfoViewController new]];
    self.view.window.rootViewController = rootTabCtrl;
}


@end
