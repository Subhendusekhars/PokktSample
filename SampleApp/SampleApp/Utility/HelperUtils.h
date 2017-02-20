//
//  HelperUtils.h
//  SampleApp
//
//  Created by Pokkt on 15/09/16.
//  Copyright © 2016 Pokkt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HelperUtils : NSObject
{
    
}

+(void)showAlertWithMessage:(NSString *)msg;
+(void)makeButtonDisable:(UIButton *)button;
+(void)makeButtonEnable:(UIButton *)button;
+ (void)setVideoButtonState:(BOOL)show  forButton:(UIButton *)button isScreenRewarded:(BOOL)isRewardedScreen;
+ (void)setInterstitialButtonState:(BOOL)show  forButton:(UIButton *)button isScreenRewarded:(BOOL)isRewardedScreen;
@end
