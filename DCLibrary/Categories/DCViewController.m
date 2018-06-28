//
//  DCViewController.m
//  DCLibrary
//
//  Created by 浩克 on 2018/6/25.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import "DCViewController.h"
#import <objc/runtime.h>
#import <MediaPlayer/MediaPlayer.h>
@interface DCViewController ()

@end

@implementation DCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    MPVolumeView *volumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
    [self.view addSubview:volumeView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidChangeActive:)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidChangeActive:)
                                                 name:UIApplicationDidBecomeActiveNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(volumeChanged:)
                                                 name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                               object:nil];
}

- (void)applicationDidChangeActive:(NSNotification *)notification {
    if ([notification.name isEqualToString:UIApplicationDidBecomeActiveNotification]) {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(volumeChanged:)
                                                     name:@"AVSystemController_SystemVolumeDidChangeNotification"
                                                   object:nil];
    } else {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    }
}

- (void)volumeChanged:(NSNotification *)notification
{
    NSLog(@"%@", notification);
    float volume =
    [[[notification userInfo]
      objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"]
     floatValue];
    NSLog(@"%f", volume);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//override func viewSafeAreaInsetsDidChange() {
//    navigationBarH = view.safeAreaInsets.top + 44
//}

- (void)viewSafeAreaInsetsDidChange {
    NSLog(@"%ld", self.view.safeAreaInsets.top);
}

@end
