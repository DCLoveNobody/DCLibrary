//
//  UIImage+DCAdd.h
//  DCLibrary
//
//  Created by 浩克 on 2018/11/21.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (DCAdd)

- (UIImage *)dc_imageByCropToWidthScale:(CGFloat)widthScale heightScale:(CGFloat)heightScale;

- (UIImage *)dc_imageByCropToRect:(CGRect)rect;
@end

NS_ASSUME_NONNULL_END
