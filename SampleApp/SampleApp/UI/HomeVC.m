//
//  HomeVC.m
//  SampleApp
//
//  Created by Pokkt on 16/02/16.
//  Copyright © 2016 Pokkt. All rights reserved.
//

#import "HomeVC.h"
#import "AppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "TestRewardedVC.h"
#import "PokktSDK/PokktSDK.h"
#import "PokktSDK/PokktConfig.h"
#import "BannerVC.h"
#import "HelperUtils.h"
#import "ProgressHUD.h"


@interface HomeVC ()<AdDelegate,PokktInitDelegate,BannerDelegate>

@property (nonatomic, retain) PokktConfig *pokktConfig;

@end

TestRewardedVC *rewarded ;
BannerVC *bannerVC;

@implementation HomeVC


-(void)viewDidUnload
{
    [super viewDidUnload];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [appIdTF setHidden:YES];
    [securityKeyTF setHidden:YES];
    [appIdLbl setHidden:YES];
    [securityLbl setHidden:YES];
    [settingBtn setSelected:NO];
    [self updateSubViewFrame];
    
    [self setButtonState:false];
    
    [self registerOrientationNotification];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [HelperUtils makeButtonEnable:exportLog];
    versionLbl.text = [NSString stringWithFormat:@"v%@",[PokktManager getSDKVersion]];
    
    if (!isPokktInitialize)
    {
        [self setButtonState:false];
    }
    
    self.navigationController.navigationBarHidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)settingAction:(id)sender
{
    if (settingBtn.selected) {
        [settingBtn setSelected:NO];
    }
    else
    {
        [settingBtn setSelected:YES];
    }
    
    [self updateSubViewFrame];
}

-(IBAction)initialisePokktSDK:(id)sender;
{
    if (isPokktInitialize) {
        return;
    }
    
    [ProgressHUD show:@"Initialising..."];
    
    
    self.pokktConfig  = [[PokktConfig alloc]init];
    self.pokktConfig.applicationId = appIdTF.text;
    self.pokktConfig.securityKey = securityKeyTF.text;
    self.pokktConfig.eventType = FABRIC_ANALYTICS;
    self.pokktConfig.thirdPartyUserId = @"123456";
    [PokktManager setDebug: YES];
    [PokktManager setAdDelegate:self];
    [PokktManager setBannerDelegate:self];
    [PokktManager setInitDelegate:self];
    [PokktManager initPokkt:self.pokktConfig];
}


-(IBAction)testAd:(id)sender
{
    if (isPokktInitialize)
    {
    UIButton *btn = (UIButton *)sender;
    rewarded = [[TestRewardedVC alloc] initWithNibName:@"TestRewardedVC" bundle:nil];
    rewarded.screenName = screenNameTF.text;

    if (btn.tag == 101)
    {
        if (screenNameTF.text.length > 0) {
            rewarded.isRewardedScreen = NO;
            [self.navigationController pushViewController:rewarded animated:YES];
        }
        else
        {
            [HelperUtils showAlertWithMessage:@"Please Enter Screen Name or Zone ID"];
        }
  
    }
    else if (btn.tag == 102)
    {
        if (screenNameTF.text.length > 0) {
             rewarded.isRewardedScreen = YES;
            
            [self.navigationController pushViewController:rewarded animated:YES];
        }
        else
        {
            [HelperUtils showAlertWithMessage:@"Please Enter Screen Name or Zone ID"];
        }
    }
    }
    else
    {
      [HelperUtils showAlertWithMessage:@"Pokkt sdk is not initialized."];
    }
}

-(IBAction)exportLogAction:(id)sender
{
    [PokktManager setDebug:YES];
    [PokktManager exportLog:self];
}

-(IBAction)Banner:(id)sender
{
    if (isPokktInitialize)
    {
      bannerVC = [[BannerVC alloc] initWithNibName:@"BannerVC" bundle:nil];
      [self.navigationController pushViewController:bannerVC animated:YES];
    }
    else
    {
        [HelperUtils showAlertWithMessage:@"Pokkt sdk is not initialized."];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - Pokkt Delegates

- (void)onPokktInitialised:(BOOL)isReady withMessage:(NSString *)message
{
    [rewarded onPokktInitialised:isReady withMessage:message];
    if (isReady)
    {
        isPokktInitialize = YES;
        [self setButtonState:true];
        [ProgressHUD dismiss];
        [PokktManager callBackgroundTaskCompletedHandler:^(UIBackgroundFetchResult result) {
            NSLog(@"fetch");
        }];
    }
    else
    { 
        isPokktInitialize = NO;
        [ProgressHUD showSuccess:@"Initialisation Failed!"];
    }
}

- (void)onAdAvailabilityStatus: (AdConfig *)adConfig isAdAvailable: (BOOL)isAdAvailable
{
   [rewarded onAdAvailabilityStatus:adConfig isAdAvailable:isAdAvailable];
}

- (void)onAdCachingCompleted: (AdConfig *)adConfig reward: (float)reward
{
    [rewarded onAdCachingCompleted:adConfig reward:reward];
}

- (void)onAdCachingFailed: (AdConfig *)adConfig errorMessage: (NSString *)errorMessage
{
    [rewarded onAdCachingFailed:adConfig errorMessage:errorMessage];
}

- (void)onAdClosed:(AdConfig *)adConfig
{
    [rewarded onAdClosed:adConfig];
}

- (void)onAdCompleted: (AdConfig *)adConfig
{
    [rewarded onAdCompleted:adConfig];
}

- (void)onAdDisplayed: (AdConfig *)adConfig
{
    [rewarded onAdDisplayed:adConfig];
}

- (void)onAdGratified: (AdConfig *)adConfig reward:(float)reward
{
    [rewarded onAdGratified:adConfig reward:reward];
}

- (void)onAdSkipped: (AdConfig *)adConfig
{
    [rewarded onAdSkipped:adConfig];
}

#pragma mark - Banner Delegates

- (void)onBannerLoaded:(NSString *)screenName
{
    [bannerVC onBannerLoaded:screenName];
}

- (void)onBannerLoadFailed:(NSString *)screenName errorMessage:(NSString *)errorMessage
{
    [bannerVC onBannerLoadFailed:screenName errorMessage:errorMessage];
}


#pragma mark - Orienation

-(void)registerOrientationNotification
{
    UIDeviceOrientation  m_CurrentOrientation = [[UIDevice currentDevice] orientation];
    
    if (m_CurrentOrientation == UIDeviceOrientationLandscapeLeft
        || m_CurrentOrientation == UIDeviceOrientationLandscapeRight )
    {
        [scroll setContentSize:CGSizeMake(250, 600)];
    }
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    

}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    AppDelegate *appdelegate = [UIApplication sharedApplication].delegate;
    if (appdelegate.deviceType == iPhone4s || appdelegate.deviceType == iPhone5 || appdelegate.deviceType == iPhone5s) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}

- (void)deviceOrientationDidChange:(NSNotification *)notification
{
    UIDeviceOrientation  m_CurrentOrientation = [[UIDevice currentDevice] orientation];
    if (m_CurrentOrientation == UIDeviceOrientationLandscapeLeft || m_CurrentOrientation == UIDeviceOrientationLandscapeRight ) {
        [scroll setContentSize:CGSizeMake(250, 600)];
    }
    else if (m_CurrentOrientation == UIDeviceOrientationPortrait || m_CurrentOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        [scroll setContentSize:CGSizeMake(250, 200)];
    }
    
}

#pragma mark Update UI Action

-(void)setButtonState:(BOOL)isInitialise
{
    if (isInitialise)
    {
        [HelperUtils makeButtonDisable:initializeSdkBtn];
        [HelperUtils makeButtonEnable:testNonRewarded];
        [HelperUtils makeButtonEnable:testRewarded];
        //[HelperUtils makeButtonEnable:exportLog];
        [HelperUtils makeButtonEnable:bannerBtn];
    }
    else
    {
        [HelperUtils makeButtonEnable:initializeSdkBtn];
        [HelperUtils makeButtonDisable:testNonRewarded];
        [HelperUtils makeButtonDisable:testRewarded];
        //[HelperUtils makeButtonDisable:exportLog];
        [HelperUtils makeButtonDisable:bannerBtn];
    }
}

-(void)updateSubViewFrame
{
    if (!settingBtn.selected)
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            
            [appIdTF setHidden:YES];
            [securityKeyTF setHidden:YES];
            [appIdLbl setHidden:YES];
            [securityLbl setHidden:YES];
            
        } completion:^(BOOL finished) {
            
            CGRect screeTF = screenNameTF.frame;
            screeTF.origin.y = appIdTF.frame.origin.y;
            screenNameTF.frame = screeTF;
            
            CGRect initB = initializeSdkBtn.frame;
            initB.origin.y = screenNameTF.frame.origin.y + screenNameTF.frame.size.height +8;
            initializeSdkBtn.frame = initB;
            
            
            CGRect RB = testRewarded.frame;
            RB.origin.y = initializeSdkBtn.frame.origin.y + initializeSdkBtn.frame.size.height +8;
            testRewarded.frame = RB;
            
            CGRect nonRB = testNonRewarded.frame;
            nonRB.origin.y = testRewarded.frame.origin.y + testRewarded.frame.size.height +8;
            testNonRewarded.frame = nonRB;
            
            CGRect bannerB = bannerBtn.frame;
            bannerB.origin.y = testNonRewarded.frame.origin.y + testNonRewarded.frame.size.height + 8;
            bannerBtn.frame = bannerB;
            
            CGRect exportB = exportLog.frame;
            exportB.origin.y = bannerBtn.frame.origin.y + bannerBtn.frame.size.height + 8;
            exportLog.frame = exportB;
            
 
            
        }];
    }
    else
    {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionAllowAnimatedContent animations:^{
            CGRect screeTF = screenNameTF.frame;
            screeTF.origin.y = securityKeyTF.frame.origin.y + securityKeyTF.frame.size.height +8;
            screenNameTF.frame = screeTF;
            
            CGRect initB = initializeSdkBtn.frame;
            initB.origin.y = screenNameTF.frame.origin.y + screenNameTF.frame.size.height +8;
            initializeSdkBtn.frame = initB;
            
            CGRect RB = testRewarded.frame;
            RB.origin.y = initializeSdkBtn.frame.origin.y + initializeSdkBtn.frame.size.height +8;
            testRewarded.frame = RB;

            CGRect nonRB = testNonRewarded.frame;
            nonRB.origin.y = testRewarded.frame.origin.y + testRewarded.frame.size.height +8;
            testNonRewarded.frame = nonRB;
            
            
            CGRect bannerB = bannerBtn.frame;
            bannerB.origin.y = testNonRewarded.frame.origin.y + testNonRewarded.frame.size.height + 8;
            bannerBtn.frame = bannerB;
            
            CGRect exportB = exportLog.frame;
            exportB.origin.y = bannerBtn.frame.origin.y + bannerBtn.frame.size.height +8;
            exportLog.frame = exportB;
            
 
            
        } completion:^(BOOL finished)
        {
            [appIdTF setHidden:NO];
            [securityKeyTF setHidden:NO];
            [appIdLbl setHidden:NO];
            [securityLbl setHidden:NO];
        }];
        
    }
}


@end
