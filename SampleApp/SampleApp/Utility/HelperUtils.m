//
//  HelperUtils.m
//  SampleApp
//
//  Created by Pokkt on 15/09/16.
//  Copyright © 2016 Pokkt. All rights reserved.
//

#import "HelperUtils.h"

@implementation HelperUtils

+(void)makeButtonDisable:(UIButton *)button
{
    button.layer.cornerRadius = 10; // this value vary as per your desire
    button.clipsToBounds = YES;
    [UIView transitionWithView:button
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        button.alpha = 0.3;
                        [button setEnabled:NO];
                    }
                    completion:NULL];
}

+(void)makeButtonEnable:(UIButton *)button
{
    button.layer.cornerRadius = 10; // this value vary as per your desire
    button.clipsToBounds = YES;
    [UIView transitionWithView:button
                      duration:0.4
                       options:UIViewAnimationOptionTransitionCrossDissolve
                    animations:^{
                        button.alpha = 1.0;
                        [button setEnabled:YES];
                    }
                    completion:NULL];
}

+(void)showAlertWithMessage:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"" message:msg delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

+ (void)setVideoButtonState:(BOOL)show  forButton:(UIButton *)button isScreenRewarded:(BOOL)isRewardedScreen
{
    [button setHidden:NO];
    if (!show)
    {
        if (isRewardedScreen) {
            [button setTitle:@"Show Video Ad (Stream)" forState:UIControlStateNormal];
        }
        else
        {
            [button setTitle:@"Show Video Ad (Stream)" forState:UIControlStateNormal];
        }
    }
    else
    {
        if (isRewardedScreen) {
            [button setTitle:@"Play Video Ad (Cached)" forState:UIControlStateNormal];
        }
        else
        {
            [button setTitle:@"Play Video Ad (Cached)" forState:UIControlStateNormal];
        }
        
    }
}

+ (void)setInterstitialButtonState:(BOOL)show  forButton:(UIButton *)button isScreenRewarded:(BOOL)isRewardedScreen
{
    [button setHidden:NO];
    if (!show)
    {
        if (isRewardedScreen) {
            [button setTitle:@"Show Interstitial Ad" forState:UIControlStateNormal];
        }
        else
        {
            [button setTitle:@"Show Interstitial Ad" forState:UIControlStateNormal];
        }
    }
    else
    {
        if (isRewardedScreen) {
            [button setTitle:@"Show Interstitial Ad (Cached)" forState:UIControlStateNormal];
        }
        else
        {
            [button setTitle:@"Show Interstitial Ad (Cached)" forState:UIControlStateNormal];
        }
        
    }
}



@end
