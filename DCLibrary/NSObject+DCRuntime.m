//
//  NSObject+DCRuntime.m
//  DCLibrary
//
//  Created by 浩克 on 2018/12/10.
//  Copyright © 2018 浩克. All rights reserved.
//

#import "NSObject+DCRuntime.h"
#import <objc/runtime.h>
@implementation NSObject (DCRuntime)
+ (void)inheritanceLog {
    if (![self isKindOfClass:[NSObject class]]) {
        NSLog(@"Not inhert from Foundation");
        return;
    }
    Class clazz = self;
    while (clazz != [NSObject class]) {
        NSLog(@"%s\n", class_getName(clazz));
        clazz = class_getSuperclass(clazz);
    }
    NSLog(@"NSObject");
}
@end
