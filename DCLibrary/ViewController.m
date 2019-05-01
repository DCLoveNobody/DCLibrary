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
#import "DCDownLoadOperation.h"
@interface ViewController ()
@property (nonatomic, strong) DCURLSessionManager *sessionManager;
@property (nonatomic, strong) dispatch_queue_t syncQueue;
@property (nonatomic, strong) dispatch_queue_t asyncQueue;
@property (nonatomic, strong) NSMutableArray *downloadLessons;
@property (nonatomic, strong) NSOperationQueue *downloadQueue;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self moocTestDownLoad];
}

- (void)moocTestDownLoad {
    NSString *resourceURL = @"/Users/DC/Desktop/mooc.json";
    NSData *resourceData = [NSData dataWithContentsOfFile:resourceURL];
    if (resourceData) {
        NSDictionary *moocDictionary = [NSJSONSerialization JSONObjectWithData:resourceData options:NSJSONReadingMutableContainers error:nil];
        NSArray *chapters = moocDictionary[@"results"][@"termDto"][@"chapters"];
        NSUInteger chapterindex = 1;
        for (NSDictionary *chapter in chapters) {
            NSUInteger lessonindex = 1;
            for (NSDictionary *lesson in chapter[@"lessons"]) {
                NSUInteger unitindex = 1;
                for (NSDictionary *unit in lesson[@"units"]) {
                    NSString *filePath = @"/Users/DC/Desktop/MoocDownload/计算机网络";
                    filePath = [filePath stringByAppendingPathComponent:chapter[@"name"]];
                    filePath = [filePath stringByAppendingPathComponent:lesson[@"name"]];
                    filePath = [filePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%zd.%zd.%zd %@", chapterindex, lessonindex, unitindex, unit[@"name"]]];
                    NSString *downloadURL;
                    NSDictionary *resourceInfo = [unit objectForKey:@"resourceInfo"];
                    if (resourceInfo && ![resourceInfo isKindOfClass:[NSNull class]]) {
                        NSString *videoSHDUrl = [resourceInfo objectForKey:@"videoSHDUrl"];
                        NSString *videoHDUrl = [resourceInfo objectForKey:@"videoHDUrl"];
                        NSString *textUrl = [resourceInfo objectForKey:@"textUrl"];
                        if (videoSHDUrl && ![videoSHDUrl isKindOfClass:[NSNull class]]) {
//                            downloadURL = videoSHDUrl;
//                            filePath = [filePath stringByAppendingString:@".mp4"];
                        } else if (videoHDUrl && ![videoHDUrl isKindOfClass:[NSNull class]]) {
//                            downloadURL = videoHDUrl;
//                            filePath = [filePath stringByAppendingString:@".mp4"];
                        } else if (textUrl && ![textUrl isKindOfClass:[NSNull class]]) {
                            downloadURL = textUrl;
                            filePath = [filePath stringByAppendingString:@".pdf"];
                        }
                        DCDownLoadOperation *operation = [[DCDownLoadOperation alloc] init];
                        operation.session = self.sessionManager;
                        operation.downloadURL = downloadURL;
                        operation.downloadPath = filePath;
                        if (downloadURL) {
                            unitindex++;
                            [self.downloadQueue addOperation:operation];
                        }
                    }
                }
                lessonindex++;
            }
            chapterindex++;
        }
    }
}

- (IBAction)click:(id)sender {
}

- (void)test {
}

- (DCURLSessionManager *)sessionManager {
    if (!_sessionManager) {
        _sessionManager = [DCURLSessionManager new];
    }
    return _sessionManager;
}

- (NSOperationQueue *)downloadQueue {
    if (!_downloadQueue) {
        _downloadQueue = [[NSOperationQueue alloc] init];
        _downloadQueue.maxConcurrentOperationCount = 3;
    }
    return _downloadQueue;
}
@end
