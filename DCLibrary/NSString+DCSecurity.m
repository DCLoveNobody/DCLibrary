//
//  NSString+DCSecurity.m
//  DCLibrary
//
//  Created by 浩克 on 2018/12/11.
//  Copyright © 2018 浩克. All rights reserved.
//

#import "NSString+DCSecurity.h"
#import <CommonCrypto/CommonDigest.h>
typedef NS_ENUM(NSInteger, DCHashType) {
    DCHashTypeMD5,
    DCHashTypeSHA1,
    DCHashTypeSHA256
};
@implementation NSString (DCSecurity)
- (NSString *)MD5 {
    return [self hashWithType:DCHashTypeMD5];
}
- (NSString *)SHA1 {
    return [self hashWithType:DCHashTypeSHA1];
}
- (NSString *)SHA256 {
    return [self hashWithType:DCHashTypeSHA256];
}

- (NSString *)hashWithType:(DCHashType)type {
    const char *ptr = [self UTF8String];
    NSInteger bufferSize;
    switch (type) {
        case DCHashTypeMD5:
            bufferSize = CC_MD5_DIGEST_LENGTH;
            break;
        case DCHashTypeSHA1:
            bufferSize = CC_SHA1_DIGEST_LENGTH;
            break;
        case DCHashTypeSHA256:
            bufferSize = CC_SHA256_DIGEST_LENGTH;
            break;
        default:
            return nil;
            break;
    }
    unsigned char buffer[bufferSize];
    switch (type) {
        case DCHashTypeMD5:
            CC_MD5(ptr, (CC_LONG)strlen(ptr), buffer);
            break;
        case DCHashTypeSHA1:
            CC_SHA1(ptr, (CC_LONG)strlen(ptr), buffer);
            break;
        case DCHashTypeSHA256:
            CC_SHA256(ptr, (CC_LONG)strlen(ptr), buffer);
            break;
        default:
            return nil;
            break;
    }
    NSMutableString *hashString = [NSMutableString stringWithCapacity:bufferSize * 2];
    for (int i = 0; i < bufferSize; i++) {
        [hashString appendFormat:@"%02x", buffer[i]];
    }
    return [hashString copy];
}

@end
