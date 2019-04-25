//
//  DCDownLoadOperation.m
//  DCLibrary
//
//  Created by 浩克 on 2019/4/24.
//  Copyright © 2019 dc_ironman. All rights reserved.
//

#import "DCDownLoadOperation.h"
#import "DCURLSessionManager.h"
@interface DCDownLoadOperation ()
@property (nonatomic, assign, getter=isFinished) BOOL finished;
@property (nonatomic, assign, getter=isExecuting) BOOL executing;
@end

@implementation DCDownLoadOperation
@synthesize finished = _finished;
@synthesize executing = _executing;
- (void)start {
    __weak typeof(self) weakSelf = self;
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.downloadURL]] downloadProgress:^(NSProgress *downloadProgress) {
        double progress = downloadProgress.completedUnitCount * 1.0 / downloadProgress.totalUnitCount;
        NSLog(@"progress = %lf", progress);
    } destination:^(NSURLSession *session, NSURLSessionDownloadTask *task, NSURL *URL) {
        return [NSURL fileURLWithPath:self.downloadPath];
    } completionHandler:^(NSURLResponse *response, id  _Nullable responseObject, NSError * _Nullable error) {
        weakSelf.finished = YES;
    }];
    [downloadTask resume];
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

@end
