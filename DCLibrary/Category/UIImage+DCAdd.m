//
//  UIImage+DCAdd.m
//  DCLibrary
//
//  Created by 浩克 on 2018/11/21.
//  Copyright © 2018年 浩克. All rights reserved.
//

#import "UIImage+DCAdd.h"

@implementation UIImage (DCAdd)
- (UIImage *)dc_imageByCropToWidthScale:(CGFloat)widthScale heightScale:(CGFloat)heightScale {
    CGSize size = self.size;
    CGFloat imageW = size.width;
    CGFloat imageH = size.height;
    CGFloat cropW = imageW;
    CGFloat cropH = imageH;
    if (imageW * heightScale > imageH * widthScale) { // 宽超出
        cropW = imageH * widthScale / heightScale;
    } else if (imageW * heightScale < imageH * widthScale) { //高超出
        cropH = imageW * heightScale / widthScale;
    }
    CGFloat cropX = (imageW - cropW) * 0.5;
    CGFloat cropY = (imageH - cropH) * 0.5;
    CGRect cropRect = CGRectMake(cropX, cropY, cropW, cropH);
    return [self dc_imageByCropToRect:cropRect];
}

- (UIImage *)dc_imageByCropToRect:(CGRect)rect {
    rect.origin.x *= self.scale;
    rect.origin.y *= self.scale;
    rect.size.width *= self.scale;
    rect.size.height *= self.scale;
    if (rect.size.width <= 0 || rect.size.height <= 0) return nil;
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *image = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return image;
}
@end
