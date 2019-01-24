//
//  ViewController.m
//  DCLibrary
//
//  Created by 浩克 on 2018/6/25.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import "ViewController.h"
#import "DCURLSessionManager.h"
#import "NSObject+DCRuntime.h"
#import "NSString+DCSecurity.h"
#import <AFNetworking.h>
#import "DCBubbleView.h"

@interface ViewController ()
@property (nonatomic, strong) DCURLSessionManager *sessionManager;
@property (nonatomic, strong) dispatch_queue_t syncQueue;
@property (nonatomic, strong) dispatch_queue_t asyncQueue;
@property (nonatomic, strong) NSMutableArray *downloadLessons;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self moocDownLoad];
    return;
    DCBubbleView *bubbleView = [[DCBubbleView alloc] initWithFrame:CGRectMake(0, 0, 22, 22)];
    bubbleView.center = self.view.center;
    [self.view addSubview:bubbleView];
}

- (void)moocDownLoad {
    self.downloadLessons = [NSMutableArray array];
    NSString *resourceURL = @"/Users/haoke/Desktop/Mooc";
    NSData *resourceData = [NSData dataWithContentsOfFile:resourceURL];
    if (resourceData) {
        NSDictionary *moocDictionary = [NSJSONSerialization JSONObjectWithData:resourceData options:NSJSONReadingMutableContainers error:nil];
        [self.downloadLessons addObjectsFromArray:moocDictionary[@"videos"]];
    }
    [self download];
}

- (void)download {
    if (self.downloadLessons.count <= 0) return;
    NSDictionary *video = self.downloadLessons.firstObject;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:video[@"downloadUrl"]]];
    NSURL *documentPath = [NSURL fileURLWithPath:[NSString stringWithFormat:@"/Users/haoke/Desktop/Videos/%@.mp4", video[@"name"]]];
    NSURLComponents *components = [NSURLComponents componentsWithURL:documentPath resolvingAgainstBaseURL:NO];
    __weak typeof(self) weakSelf = self;
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request downloadProgress:^(NSProgress *downloadProgress) {
        CGFloat progress = downloadProgress.completedUnitCount * 1.0 / downloadProgress.totalUnitCount;
        NSLog(@"progress = %lf", progress);
    } destination:^(NSURLSession *session, NSURLSessionDownloadTask *task, NSURL *URL) {
        return documentPath;
    } completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (weakSelf.downloadLessons.count > 0) {
            [weakSelf.downloadLessons removeObjectAtIndex:0];
            [weakSelf download];
        }
    }];
    [downloadTask resume];
}
- (IBAction)click:(id)sender {
}

- (void)test {
}

- (void)downloadTest {
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://v.stu.126.net/mooc-video/nos/mp4/2014/05/27/417033_hd.mp4?ak=99ed7479ee303d1b1361b0ee5a4abcee76495e489d9af132100c558aaad5979b143e5754443f420cbbbf91b9494778ef9e0a277710aafe2642ea4e8e83ac686efe5247b72a0b558d8a88d79d3152b74b5e32b4df98e0528866f8b0cccbc20dc6dfac4d6536764a6d54ca2d79bb9b8a9a05ec7a6a239bbe98a3415ac79332c36998dadda24653d8c14954d65fb8e477caa507ceb1f61e74fd7d0a6a7647f4f4bb133034bdd7ff8fe592787597dcd2dbb0"]];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentPath = [[fileManager
                            URLsForDirectory:NSDocumentDirectory
                            inDomains:NSUserDomainMask] lastObject];
    documentPath = [documentPath URLByAppendingPathComponent:@"123.mp4"];
    NSURLSessionDownloadTask *downloadTask = [self.sessionManager downloadTaskWithRequest:request downloadProgress:^(NSProgress *downloadProgress) {
        CGFloat progress = downloadProgress.completedUnitCount * 1.0 / downloadProgress.totalUnitCount;
        NSLog(@"progress = %lf", progress);
    } destination:^(NSURLSession *session, NSURLSessionDownloadTask *task, NSURL *URL) {
        return documentPath;
    } completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        NSLog(@"success");
    }];
}

- (DCURLSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [DCURLSessionManager new];
    }
    return _sessionManager;
}

@end
