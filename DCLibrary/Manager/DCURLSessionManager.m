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
typedef NSURL * (^DCURLSessionTaskDownloadCompleteBlock)(NSURLSession *, NSURLSessionDownloadTask *, NSURL *);

@interface DCURLSessionManagerTaskDelegate : NSObject<NSURLSessionDelegate, NSURLSessionTaskDelegate, NSURLSessionDataDelegate, NSURLSessionDownloadDelegate>
@property (nonatomic, weak) DCURLSessionManager *manager;
@property (nonatomic, strong) NSMutableData *mutableData;
@property (nonatomic, strong) NSProgress *downloadProgress;
@property (nonatomic, strong) NSProgress *uploadProgress;
@property (nonatomic, copy) DCURLSessionTaskProgressBlock uploadProgressBlock;
@property (nonatomic, copy) DCURLSessionTaskProgressBlock downloadProgressBlock;
@property (nonatomic, copy) DCURLSessionTaskCompletionHandler completionHandler;
@property (nonatomic, copy) DCURLSessionTaskDownloadCompleteBlock downloadCompleteBlock;
@property (nonatomic, copy) NSURL *destinationURL;
@end

@implementation DCURLSessionManagerTaskDelegate

- (instancetype)initWithTask:(NSURLSessionTask *)task {
    self = [super init];
    if (!self) {
        return nil;
    }
    _mutableData = [NSMutableData data];
    _downloadProgress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    _uploadProgress = [[NSProgress alloc] initWithParent:nil userInfo:nil];
    return self;
}
#pragma mark - NSURLSessionTaskDelegate
- (void)URLSession:(NSURLSession *)session task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (self.completionHandler) {
        NSData *data = nil;
        if (self.mutableData) {
            data = [self.mutableData copy];
            self.mutableData = nil;
        }
        self.completionHandler(task.response, data, error);
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
    [self.mutableData appendData:data];
    self.downloadProgress.totalUnitCount = dataTask.countOfBytesExpectedToReceive;
    self.downloadProgress.completedUnitCount = dataTask.countOfBytesReceived;

    if (self.downloadProgressBlock) {
        self.downloadProgressBlock(self.downloadProgress);
    }
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
    if (self.downloadCompleteBlock) {
        self.destinationURL = self.downloadCompleteBlock(session, downloadTask, location);
    }
    if (self.destinationURL) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSError *error = nil;
        [fileManager moveItemAtURL:location toURL:self.destinationURL error:&error];
        if (error) {
            
        }
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    self.downloadProgress.totalUnitCount = totalBytesExpectedToWrite;
    self.downloadProgress.completedUnitCount = totalBytesWritten;
    
    if (self.downloadProgressBlock) {
        self.downloadProgressBlock(self.downloadProgress);
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    self.downloadProgress.totalUnitCount = expectedTotalBytes;
    self.downloadProgress.completedUnitCount = fileOffset;
    
    if (self.downloadProgressBlock) {
        self.downloadProgressBlock(self.downloadProgress);
    }
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
    _sessionConfigutation = configuration;
    _operationQueue = [[NSOperationQueue alloc] init];
    _operationQueue.maxConcurrentOperationCount = 1;
    _session = [NSURLSession sessionWithConfiguration:configuration delegate:self delegateQueue:_operationQueue];
    _mutableTaskDelegatesKeyedByTaskIdentifier = [NSMutableDictionary dictionary];
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

- (void)addDelegateForDownloadTask:(NSURLSessionTask *)task
              downloadProgress:(nullable void (^)(NSProgress *uploadProgress))downloadProgressBlock
                   destination:(NSURL * (^)(NSURLSession *, NSURLSessionDownloadTask *, NSURL *))destination
             completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {
    DCURLSessionManagerTaskDelegate *delegate = [[DCURLSessionManagerTaskDelegate alloc] initWithTask:task];
    delegate.downloadProgressBlock = downloadProgressBlock;
    delegate.completionHandler = completionHandler;
    delegate.downloadCompleteBlock = destination;
    self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)] = delegate;
}

- (DCURLSessionManagerTaskDelegate *)delegateForTask:(NSURLSessionTask *)task {
    DCURLSessionManagerTaskDelegate *delegate = self.mutableTaskDelegatesKeyedByTaskIdentifier[@(task.taskIdentifier)];
    return delegate;
}

- (void)removeDelegateForTask:(NSURLSessionTask *)task {
    [self.mutableTaskDelegatesKeyedByTaskIdentifier removeObjectForKey:@(task.taskIdentifier)];
}

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))completionHandler {
    return [self dataTaskWithRequest:request uploadProgress:nil downloadProgress:nil completionHandler:completionHandler];
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

- (NSURLSessionDownloadTask *)downloadTaskWithRequest:(NSURLRequest *)request
                                     downloadProgress:(void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                                          destination:(NSURL * (^)(NSURLSession *, NSURLSessionDownloadTask *, NSURL *))destination
                                    completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler {
    NSURLSessionDownloadTask *downloadTask = [self.session downloadTaskWithRequest:request];
    [self addDelegateForDownloadTask:downloadTask downloadProgress:downloadProgressBlock destination:destination completionHandler:completionHandler];
    return downloadTask;
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
    NSURLRequest *redirectRequest = request;
    if (completionHandler) {
        completionHandler(redirectRequest);
    }
}

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didReceiveChallenge:(NSURLAuthenticationChallenge *)challenge
 completionHandler:(void (^)(NSURLSessionAuthChallengeDisposition disposition, NSURLCredential *credential))completionHandler
{
    NSURLSessionAuthChallengeDisposition disposition = NSURLSessionAuthChallengePerformDefaultHandling;
    NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
    if (completionHandler) {
        completionHandler(disposition, credential);
    }
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
    DCURLSessionManagerTaskDelegate *delegate = [self delegateForTask:task];
    
    if (delegate) {
        [delegate URLSession:session task:task didCompleteWithError:error];
        [self removeDelegateForTask:task];
    }
}

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
    NSCachedURLResponse *cachedResponse = proposedResponse;
    if (completionHandler) {
        completionHandler(cachedResponse);
    }
}


#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location
{
    DCURLSessionManagerTaskDelegate *delegate = self.mutableTaskDelegatesKeyedByTaskIdentifier[@(downloadTask.taskIdentifier)];
    if (delegate) {
        [delegate URLSession:session downloadTask:downloadTask didFinishDownloadingToURL:location];
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite
{
    DCURLSessionManagerTaskDelegate *delegate = self.mutableTaskDelegatesKeyedByTaskIdentifier[@(downloadTask.taskIdentifier)];
    if (delegate) {
        [delegate URLSession:session downloadTask:downloadTask didWriteData:bytesWritten totalBytesWritten:totalBytesWritten totalBytesExpectedToWrite:totalBytesExpectedToWrite];
    }
}

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes
{
    DCURLSessionManagerTaskDelegate *delegate = self.mutableTaskDelegatesKeyedByTaskIdentifier[@(downloadTask.taskIdentifier)];
    if (delegate) {
        [delegate URLSession:session downloadTask:downloadTask didResumeAtOffset:fileOffset expectedTotalBytes:expectedTotalBytes];
    }
}
@end
