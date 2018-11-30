//
//  DCURLSessionManager.h
//  DCLibrary
//
//  Created by 浩克 on 2018/11/5.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCURLSessionManager : NSObject
- (NSURLSessionDataTask *)dataTaskWithRequest:(NSURLRequest *)request completionHandler:(void (^)(NSData *data, NSURLResponse *response, NSError *error))completionHandler;
@end

