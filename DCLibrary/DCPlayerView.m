//
//  DCPlayerView.m
//  DCLibrary
//
//  Created by 浩克 on 2018/12/3.
//  Copyright © 2018 浩克. All rights reserved.
//

#import "DCPlayerView.h"
#import <AVFoundation/AVFoundation.h>
static NSString * const DCPlayerStatusKeyPath = @"status";
static NSString * const DCPlayerLoadedTimeRangesKeyPath = @"loadedTimeRanges";
@interface DCPlayerView()
@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@end

@implementation DCPlayerView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        _player = [[AVPlayer alloc] init];
        self.playerLayer.player = _player;
        self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    }
    return self;
}

- (void)setUrl:(NSString *)url {
    _url = url;
    [self removeObersvers];
    self.playerItem = [[AVPlayerItem alloc] initWithURL:[NSURL URLWithString:url]];
    [self addObersvers];
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}

- (AVPlayerLayer *)playerLayer {
    return (AVPlayerLayer *)self.layer;
}

- (AVPlayer *)player {
    return self.playerLayer.player;
}

- (void)removeObersvers {
    [self.playerItem removeObserver:self forKeyPath:DCPlayerStatusKeyPath];
    [self.playerItem removeObserver:self forKeyPath:DCPlayerLoadedTimeRangesKeyPath];
}

- (void)addObersvers {
    [self.playerItem addObserver:self forKeyPath:DCPlayerStatusKeyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
    [self.playerItem addObserver:self forKeyPath:DCPlayerLoadedTimeRangesKeyPath options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:DCPlayerStatusKeyPath]) {
        
    } else if ([keyPath isEqualToString:DCPlayerLoadedTimeRangesKeyPath]) {
        
    }
}

@end
