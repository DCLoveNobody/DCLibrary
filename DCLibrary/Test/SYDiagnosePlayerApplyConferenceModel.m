//
//  SYLivePlayerApplyConferenceModel.m
//  SoYoungMobile40
//
//  Created by Jeakon on 2017/7/14.
//  Copyright © 2017年 soyoung. All rights reserved.
//

#import "SYDiagnosePlayerApplyConferenceModel.h"

@implementation SYDiagnosePlayerApplyConferenceModel

- (void)prepareLoad
{
    [super prepareLoad];
    [self.dataParams cdf_safeSetObject:self.zhiboId forKey:@"zhibo_id"];
}

- (NSString *)apiUrl
{
    return @"live/applyaddzhibo";
}

@end
