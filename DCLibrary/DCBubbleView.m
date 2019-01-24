//
//  DCBubbleView.m
//  DCLibrary
//
//  Created by 浩克 on 2019/1/18.
//  Copyright © 2019 浩克. All rights reserved.
//

#import "DCBubbleView.h"
static NSString * const scaleAnimationKey = @"scaleAnimation";
static NSString * const pathAnimationKey = @"animationGroup";
@interface DCBubbleView () <CAAnimationDelegate>
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) NSMutableArray<UIView *> *staticViews;
@end

@implementation DCBubbleView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.staticViews = [NSMutableArray array];
        [self setupSubViews];
        [self setupTimer];
    }
    return self;
}

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (!newSuperview) {
        [self.timer invalidate];
    }
}

- (void)setupSubViews {
    self.backgroundColor = [UIColor whiteColor];
    for (int i = 0; i < 4; i++) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.frame = self.bounds;
        UIColor *corlor;
        if (i == 0) {
            corlor = [UIColor greenColor];
        } else if (i == 1) {
            corlor = [UIColor blueColor];
        } else if (i == 2) {
            corlor = [UIColor yellowColor];
        } else {
            corlor = [UIColor purpleColor];
        }
        imageView.backgroundColor = corlor;
        imageView.layer.cornerRadius = self.bounds.size.width * 0.5;
        imageView.clipsToBounds = YES;
        imageView.layer.borderWidth = 1;
        imageView.layer.borderColor = [UIColor greenColor].CGColor;
        [self addSubview:imageView];
        [self.staticViews addObject:imageView];
    }
}

- (void)setupTimer {
    __weak typeof(self) weakSelf = self;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 repeats:YES block:^(NSTimer * _Nonnull timer) {
        [weakSelf bubbleAnimation];
    }];
}

- (void)bubbleAnimation {
    [self scaleAnimation];
}

- (void)scaleAnimation {
    UIView *animationView = self.staticViews.lastObject;
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.fromValue = @(0.1);
    scaleAnimation.toValue = @(1);
    scaleAnimation.delegate = self;
    scaleAnimation.duration = 0.5;
    [scaleAnimation setValue:animationView forKey:scaleAnimationKey];
    
    [self.staticViews removeLastObject];
    [animationView.layer addAnimation:scaleAnimation forKey:scaleAnimationKey];
}

- (void)pathAnimation:(UIView *)animationView {
    if (!animationView) return;
    CAKeyframeAnimation *pathAnimation = [CAKeyframeAnimation animation];
    pathAnimation.timingFunction =  [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    pathAnimation.keyPath = @"position";
    UIBezierPath *path = [[UIBezierPath alloc] init];
    CGFloat oX = animationView.center.x;
    CGFloat oY = animationView.center.y;
    CGFloat eX = oX;
    CGFloat eY = oY - 80;
    CGFloat t = (arc4random() % 40);
    CGPoint cp1 = CGPointMake(oX - t, ((oY + eY) / 2));
    CGPoint cp2 = CGPointMake(oX + t, cp1.y);
    [path moveToPoint:CGPointMake(oX, oY)];
    [path addCurveToPoint:CGPointMake(eX, eY) controlPoint1:cp1 controlPoint2:cp2];
    pathAnimation.path = path.CGPath;
    
    CABasicAnimation *alphaAnimation = [CABasicAnimation animation];
    alphaAnimation.keyPath = @"opacity";
    alphaAnimation.fromValue = @(1);
    alphaAnimation.toValue = @(0);
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.fromValue = @(1);
    scaleAnimation.toValue = @(0.8);
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.delegate = self;
    animationGroup.duration = 1.5;
    animationGroup.animations = @[pathAnimation, alphaAnimation, scaleAnimation];
    [animationGroup setValue:animationView forKey:pathAnimationKey];
    
    [animationView.layer addAnimation:animationGroup forKey:pathAnimationKey];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    if ([anim valueForKey:scaleAnimationKey]) {
        UIView *animationView = [anim valueForKey:scaleAnimationKey];
        [animationView.layer removeAllAnimations];
        [self pathAnimation:animationView];
    } else if ([anim valueForKey:pathAnimationKey]) {
        UIView *animationView = [anim valueForKey:pathAnimationKey];
        [animationView.layer removeAllAnimations];
        [self.staticViews insertObject:animationView atIndex:0];
        animationView.frame = self.bounds;
        [self insertSubview:animationView atIndex:0];
    }
}

@end
