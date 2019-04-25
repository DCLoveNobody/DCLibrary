//
//  DCDownLoadOperation.h
//  DCLibrary
//
//  Created by 浩克 on 2019/4/24.
//  Copyright © 2019 dc_ironman. All rights reserved.
//

#import <Foundation/Foundation.h>
@class DCURLSessionManager;
NS_ASSUME_NONNULL_BEGIN

@interface DCDownLoadOperation : NSOperation
@property (nonatomic, weak) DCURLSessionManager *session;
@property (nonatomic, copy) NSString *downloadURL;
@property (nonatomic, copy) NSString *downloadPath;
@end

NS_ASSUME_NONNULL_END
