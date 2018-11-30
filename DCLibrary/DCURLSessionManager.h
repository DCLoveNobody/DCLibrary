//
//  DCURLSessionManager.h
//  DCLibrary
//
//  Created by 浩克 on 2018/11/5.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCURLSessionManager : NSObject
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSURLResponse *, NSData *, NSError *))completionHandler;

- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request
                               uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgressBlock
                             downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgressBlock
                            completionHandler:(nullable void (^)(NSURLResponse *response, id _Nullable responseObject,  NSError * _Nullable error))completionHandler;
@end

