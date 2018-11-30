//
//  ViewController.m
//  DCLibrary
//
//  Created by 浩克 on 2018/6/25.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import "ViewController.h"
#import "DCURLSessionManager.h"
#import <AFNetworking.h>
@interface ViewController ()
@property (nonatomic, strong) DCURLSessionManager *sessionManager;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://img2.soyoung.com/tieba/web/20180403/7/20180403185104874_152_152.jpg"]];
    NSURLSessionDataTask *task = [self.sessionManager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        UIImage *image = [UIImage imageWithData:data];
        NSLog(@"");
    }];
    [task resume];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    NSURLSessionDataTask *aftask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        UIImage *image = [UIImage imageWithData:responseObject];
        NSLog(@"");
    }];
    [aftask resume];
}

- (DCURLSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [DCURLSessionManager new];
    }
    return _sessionManager;
}

@end
