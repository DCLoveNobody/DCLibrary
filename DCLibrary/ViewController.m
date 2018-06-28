//
//  ViewController.m
//  DCLibrary
//
//  Created by 浩克 on 2018/6/25.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import "ViewController.h"
#import "Person.h"
#import "DCViewController.h"
#import <objc/runtime.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    

    
    
    [self.navigationController pushViewController:[[DCViewController alloc] init] animated:true];
    
    
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

void volumeListenerCallback (
                             void                     *inClientData,
                             AudioSessionPropertyID   inID,
                             UInt32                   inDataSize,
                             const void               *inData
                             ){
    const float*volumePointer = inData;
    float volume= *volumePointer;
    NSLog(@"volumeListenerCallback %f", volume);
}

- (void)viewWillAppear:(BOOL)animated {
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
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
- (IBAction)touch:(id)sender {
    [self animation];
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

- (void)animation {
}

- (IBAction)two:(id)sender {
    [UIView animateWithDuration:2 delay:0 usingSpringWithDamping:0.1 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseIn animations:^{
        CGRect frame = self.imageView.frame;
        self.imageView.frame = CGRectMake(frame.origin.x, frame.origin.y - 10, frame.size.width, frame.size.height);
    } completion:^(BOOL finished) {

    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
