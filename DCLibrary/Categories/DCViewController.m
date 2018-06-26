//
//  DCViewController.m
//  DCLibrary
//
//  Created by 浩克 on 2018/6/25.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import "DCViewController.h"
#import <objc/runtime.h>
@interface DCViewController ()

@end

@implementation DCViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIView *view = [[UIView alloc] init];
    UIView *view1 = [[UIView alloc] init];
    UIView *view2 = [[UIView alloc] init];
    UIView *view3 = [[UIView alloc] init];
    NSLog(@"%ld", self.view.safeAreaInsets.top);
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
