//
//  NSString+DCSecurity.h
//  DCLibrary
//
//  Created by 浩克 on 2018/12/11.
//  Copyright © 2018 浩克. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSString (DCSecurity)
- (NSString *)MD5;
- (NSString *)SHA1;
- (NSString *)SHA256;
@end

NS_ASSUME_NONNULL_END
