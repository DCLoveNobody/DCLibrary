//
//  DCURLSessionManager.m
//  DCLibrary
//
//  Created by 浩克 on 2018/11/5.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import "DCURLSessionManager.h"
typedef void (^DCURLSessionTaskProgressBlock)(NSProgress *);
typedef void (^DCURLSessionTaskCompletionHandler)(NSURLResponse *response, id responseObject, NSError *error);

@interface DCURLSessionManagerTaskDelegate : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, weak) DCURLSessionManager *manager;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSProgress *downloadProgress;
@property (nonatomic, strong) NSProgress *uploadProgress;
@property (nonatomic, copy) DCURLSessionTaskProgressBlock uploadProgressBlock;
@property (nonatomic, copy) DCURLSessionTaskProgressBlock downloadProgressBlock;
@property (nonatomic, copy) DCURLSessionTaskCompletionHandler completionHandler;
@end

@implementation DCURLSessionManagerTaskDelegate

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    self = [super init];
    if (!self) {
        return nil;
    }
    _mutableData = [NSMutableData data];
    _downloadProgress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    return self;
}
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    NSLog(@"");
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    [self.mutableData appendData:data];
    self.downloadProgress.totalUnitCount = dataTask.countOfBytesExpectedToReceive;
    self.downloadProgress.completedUnitCount = dataTask.countOfBytesReceived;
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    NSLog(@"");
}

@end

@interface DCURLSessionManager() <NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, strong) NSURLSession *session;
@property (nonatomic, strong) NSOperationQueue *operationQueue;
@property (nonatomic, strong) NSURLSessionConfiguration *sessionConfigutation;
@property (nonatomic, readwrite, strong) NSMutableDictionary *mutableTaskDelegatesKeyedByTaskIdentifier;
@end

@implementation DCURLSessionManager

- (instancetype)init
{
    return [self initWithSessionConfiguration:nil];
}

- (instancetype)initWithSessionConfiguration:(NSURLSessionConfiguration *)configuration {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    if (!configuration) {
        configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    }
    self.sessionConfigutation = configuration;
    self.operationQueue = [[NSOperationQueue alloc] init];
    self.operationQueue.maxConcurrentOperationCount = 1;
    self.session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:self.operationQueue];
    
    return self;
}

- (void)addDelegateForDataTask:(NSURLSessionTask *)task
              uploadProgress:(nullable void (^)(NSProgress *uploadProgress))
            uploadProgressBlock
            downloadProgress:(nullable void (^)(NSProgress *uploadProgress))downloadProgressBlock
           completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {
    DCURLSessionManagerTaskDelegate *delegate = [[DCURLSessionManagerTaskDelegate alloc] initWithTask:task];
    delegate.uploadProgressBlock = uploadProgressBlock;
    delegate.downloadProgressBlock = downloadProgressBlock;
    delegate.completionHandler = completionHandler;
    self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)] = delegate;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];

    // dataTask关联相应的delegate
    [self addDelegateForDataTask:dataTask uploadProgress:uploadProgressBlock downloadProgress:downloadProgressBlock completionHandler:completionHandler];
    
    return dataTask;
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler {
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    return dataTask;
}

#pragma mark - NSURLSessionDelegate

- (void)URLSession:(NSURLSession *)session
didBecomeInvalidWithError:(NSError *)error
{
   
}

- (void)URLSession:(NSURLSession *)session
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
willPerformHTTPRedirection:(NSHTTPURLResponse *)response
        newRequest:(NSURLRequest *)request
 completionHandler:(void (^)(NSURLRequest *))completionHandler
{
    
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
 needNewBodyStream:(void (^)(NSInputStream *bodyStream))completionHandler
{
    
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
   didSendBodyData:(int64_t)bytesSent
    totalBytesSent:(int64_t)totalBytesSent
totalBytesExpectedToSend:(int64_t)totalBytesExpectedToSend
{
    
    
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error
{

}

#if AF_CAN_INCLUDE_SESSION_TASK_METRICS
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didFinishCollectingMetrics:(NSURLSessionTaskMetrics *)metrics
{
    
}
#endif

#pragma mark - NSURLSessionDataDelegate

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler
{
    NSURLSessionResponseDisposition disposition = NSURLSessionResponseAllow;
    if (completionHandler) {
        completionHandler(disposition);
    }
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didBecomeDownloadTask:(NSURLSessionDownloadTask *)downloadTask
{
    NSLog(@"");
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data
{
    DCURLSessionManagerTaskDelegate *delegate = self.mutableTaskDelegatesKeyedByTaskIdentifier[@(dataTask.taskIdentifier)];
    [delegate URLSession:session dataTask:dataTask didReceiveData:data];
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
 willCacheResponse:(NSCachedURLResponse *)proposedResponse
 completionHandler:(void (^)(NSCachedURLResponse *cachedResponse))completionHandler
{
    NSLog(@"");
}


#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    
    
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    
}
@end
