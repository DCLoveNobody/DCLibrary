//
//  Person.m
//  DCLibrary
//
//  Created by 浩克 on 2018/6/25.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import "Person.h"
#import <objc/runtime.h>
@implementation Person
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = [self class];
        SEL originalSelector = NSSelectorFromString(@"dealloc");
        SEL swizzledSelector = @selector(DC_dealloc);
        Method originalMethod = class_getInstanceMethod(class, NSSelectorFromString(@"dealloc"));
        Method swizzledMethod = class_getInstanceMethod(class, @selector(DC_dealloc));
        BOOL didAddMethod =
        class_addMethod(class,
                        originalSelector,
                        method_getImplementation(swizzledMethod),
                        method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod) {
            class_replaceMethod(class,
                                swizzledSelector,
                                method_getImplementation(originalMethod),
                                method_getTypeEncoding(originalMethod));
        } else {
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    });
}

- (void)DC_dealloc {
    NSLog(@"%@ dealloc", NSStringFromClass([self class]));
    [self DC_dealloc];
}

@end
