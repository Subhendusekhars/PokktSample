//
//  TestRewardedVC.m
//  SampleApp
//
//  Created by Pokkt on 17/02/16.
//  Copyright © 2016 Pokkt. All rights reserved.
//

#import "TestRewardedVC.h"
#import "AppDelegate.h"
#import "ProgressHUD.h"
#import "HelperUtils.h"


#define ErnedPoints @"Points"
#define userDefaluts [NSUserDefaults standardUserDefaults]

@interface TestRewardedVC ()

@property (nonatomic, strong) AppDelegate *appdelegate;
@property (nonatomic, strong) PokktConfig *pokktConfig;
@property (nonatomic) float point;


@end

@implementation TestRewardedVC
@synthesize screenName,isRewardedScreen;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.point = 0.0f;
    // Do any additional setup after loading the view from its nib.
    [self setButtonState];
    [self setUpAdConfig];
    [self registerNotification];
    [self updatepointsEarned];
    [self setUpNavigationBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self setVideoButtonState:NO];
    [self setInterstitialButtonState:NO];
    versionLbl.text = [NSString stringWithFormat:@"v%@",[PokktManager getSDKVersion]];

}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
    
}

-(void)setUpNavigationBar
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.backgroundColor = [UIColor clearColor];
    label.font = [UIFont boldSystemFontOfSize:16.0];
    label.shadowColor = [UIColor colorWithWhite:0.0 alpha:0.5];
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = label;
    if (self.isRewardedScreen)
    {
         label.text = @"Rewarded Ad";
    }
    else
    {
        label.text = @"Non-Rewarded Ad";
    }
   
    [label sizeToFit];
    NSArray *ver = [[UIDevice currentDevice].systemVersion componentsSeparatedByString:@"."];
    if ([[ver objectAtIndex:0] intValue] >= 7) {
        // iOS 7.0 or later
        self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:65/255.0 green:156/255.0 blue:227/255.0 alpha:1.0];
        self.navigationController.navigationBar.translucent = NO;
    }else {
        // iOS 6.1 or earlier
        self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:65/255.0 green:156/255.0 blue:227/255.0 alpha:1.0];
    }
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"< Back" style:UIBarButtonItemStylePlain
                                                                     target:self action:@selector(backAction:)];
    
    [anotherButton setTintColor:[UIColor whiteColor]];
    NSUInteger size = 15;
    UIFont * font = [UIFont boldSystemFontOfSize:size];
    NSDictionary * attributes = @{NSFontAttributeName: font};
    [anotherButton setTitleTextAttributes:attributes forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = anotherButton;
}

-(IBAction)backAction:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpAdConfig
{
    self.adConfig = [[AdConfig alloc] init];
    self.adConfig.screenName = self.screenName;
    self.adConfig.isRewarded = self.isRewardedScreen;
    self.adConfig.shouldAllowSkip = YES;
    self.adConfig.defaultSkipTime = 10;
    self.adConfig.adFormat = VIDEO;

    
    self.adConfigInterstitial = [[AdConfig alloc] init];
    self.adConfigInterstitial.screenName = self.screenName;
    self.adConfigInterstitial.isRewarded = self.isRewardedScreen;
    self.adConfigInterstitial.shouldAllowSkip = YES;
    self.adConfigInterstitial.defaultSkipTime = 10;
    self.adConfigInterstitial.adFormat = INTERSTITIAL;
}

#pragma mark - Button Action

- (IBAction)videoButtonActions:(UIButton *)sender {
    if (sender.tag == 1)
    {
        if (self.adConfig != nil)
        {
            self.adConfig = nil;
        }
        [ProgressHUD show:@"Caching Ad..."];

        if (self.adConfig == nil)
        {
            [self setUpAdConfig];
        }
        [PokktManager cacheAd:self.adConfig];
        [HelperUtils makeButtonDisable:playAdBtn];
    }
    else if (sender.tag == 2)
    {
        [PokktManager checkAdAvailability:self.adConfig];
    }
}

-(IBAction)chacheInterstitial:(id)sender
{
    if (self.adConfigInterstitial != nil)
    {
        self.adConfigInterstitial = nil;
    }
    [ProgressHUD show:@"Caching Interstitial..."];
    if (self.adConfigInterstitial == nil)
    {
        [self setUpAdConfig];
    }
    [PokktManager cacheAd:self.adConfigInterstitial];
    [HelperUtils makeButtonDisable:showInterstitial];
}

-(IBAction)showInterstitial:(id)sender
{
   // [PokktManager showAd:self.adConfigInterstitial viewController:self];
  [PokktManager checkAdAvailability:self.adConfigInterstitial];
}


#pragma mark - Private Methods

- (void)updatepointsEarned {
    if([userDefaluts objectForKey:ErnedPoints])
    {
        self.point = [[userDefaluts objectForKey:ErnedPoints] floatValue];
        self.pointNumLbl.text = [NSString stringWithFormat:@"Points earned : %f",self.point];
    }
}

#pragma mark - Pokkt Delegates

- (void)onPokktInitialised:(BOOL)isReady withMessage:(NSString *)message
{
    
    if (isReady)
    {
        NSLog(@"PokktSDK is ready");
    }
    else
    {
        NSLog(@"PokktSDK is not ready");
    }
}

- (void)onAdAvailabilityStatus: (AdConfig *)adConfig isAdAvailable: (BOOL)isAdAvailable
{
    NSLog(@"Ad is available");
    if (isAdAvailable)
    {
        if (adConfig.adFormat == VIDEO)
        {
            [PokktManager showAd:self.adConfig viewController:self];
        }
        else if (adConfig.adFormat == INTERSTITIAL)
        {
            [PokktManager showAd:self.adConfigInterstitial viewController:self];
        }
    }
    else
    {
        NSString *str = @"";
        if (adConfig.isRewarded) {
            str = @"rewarded";
        }
        else
        {
            str = @"non rewarded";
        }
        [HelperUtils showAlertWithMessage:[NSString stringWithFormat:@"%@ %@ ad not available",adConfig.screenName, str]];
    }
}

- (void)onAdCachingCompleted: (AdConfig *)adConfig reward: (float)reward
{
    if (adConfig.adFormat == VIDEO)
    {
        [self setVideoButtonState:YES];
        [HelperUtils makeButtonEnable:playAdBtn];
    }
    else if (adConfig.adFormat == INTERSTITIAL)
    {
        [self setInterstitialButtonState:YES];
        [HelperUtils makeButtonEnable:showInterstitial];
    }
    
    [ProgressHUD dismiss];
    
}

- (void)onAdCachingFailed: (AdConfig *)adConfig errorMessage: (NSString *)errorMessage
{
    NSString *str = @"";
    if (adConfig.isRewarded)
    {
        str = @"rewarded";
    }
    else
    {
        str = @"non rewarded";
    }
   
    if (adConfig.adFormat == VIDEO)
    {
        [HelperUtils makeButtonEnable:playAdBtn];
        [self setVideoButtonState:NO];
    }
    else if (adConfig.adFormat == INTERSTITIAL)
    {
        [HelperUtils makeButtonEnable:showInterstitial];
        [self setInterstitialButtonState:NO];
    }
    
    [ProgressHUD dismiss];
    [HelperUtils showAlertWithMessage:[NSString stringWithFormat:@"%@ %@ failed with reason:%@",adConfig.screenName, str,errorMessage]];

}

- (void)onAdClosed:(AdConfig *)adConfig
{
    if (adConfig.adFormat == VIDEO)
    {
        [self setVideoButtonState:NO];
    }
    else if (adConfig.adFormat == INTERSTITIAL)
    {
        [self setInterstitialButtonState:NO];
    }

    self.navigationController.navigationBarHidden = NO;
    
    [HelperUtils showAlertWithMessage:@"Video is closed"];
}

- (void)onAdCompleted: (AdConfig *)adConfig
{
    [HelperUtils showAlertWithMessage:@"Video is completed"];
}

- (void)onAdDisplayed: (AdConfig *)adConfig
{
    self.navigationController.navigationBarHidden = YES;
    [HelperUtils showAlertWithMessage:@"Video is displayed"];
}


- (void)onAdGratified: (AdConfig *)adConfig reward:(float)reward
{
    if([userDefaluts objectForKey:ErnedPoints])
    {
        self.point = [[userDefaluts objectForKey:ErnedPoints] floatValue];
    }
    if (reward > 0)
    {
        self.point += reward;
        [userDefaluts setValue:[NSString stringWithFormat:@"%f",self.point] forKey:ErnedPoints];
        [userDefaluts synchronize];
        [self updatepointsEarned];
    }
    
}

- (void)onAdSkipped: (AdConfig *)adConfig
{
    [HelperUtils showAlertWithMessage:@"Video is skip"];
}


-(void)showToast:(NSNotification *)note
{
    NSString *message = note.object;
    
    if (message != nil && message.length > 0)
    {
        [PokktManager showToast:message viewController:self];
    }
}

#pragma mark - Orienation

-(void)registerNotification
{
    UIDeviceOrientation  m_CurrentOrientation = [[UIDevice currentDevice] orientation];
    if (m_CurrentOrientation == UIDeviceOrientationLandscapeLeft || m_CurrentOrientation == UIDeviceOrientationLandscapeRight ) {
        [scroll setContentSize:CGSizeMake(250, 150)];
    }
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    
    [[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(deviceOrientationDidChange:) name: UIDeviceOrientationDidChangeNotification object: nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showToast:)
                                                 name:@"toastMessage"
                                               object:nil];

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
        [scroll setContentSize:CGSizeMake(250, 150)];
    }
    else if (m_CurrentOrientation == UIDeviceOrientationPortrait || m_CurrentOrientation == UIDeviceOrientationPortraitUpsideDown)
    {
        [scroll setContentSize:CGSizeMake(250, 200)];
    }
}

#pragma mark Update UI

- (void)setVideoButtonState:(BOOL)show
{
    [HelperUtils setVideoButtonState:show forButton:playAdBtn isScreenRewarded:self.isRewardedScreen];
}

- (void)setInterstitialButtonState:(BOOL)show
{
    [HelperUtils setInterstitialButtonState:show forButton:showInterstitial isScreenRewarded:self.isRewardedScreen];
}

-(void)setButtonState
{
    [HelperUtils makeButtonEnable:startCaching];
    [HelperUtils makeButtonEnable:playAdBtn];
    [HelperUtils makeButtonEnable:interstitialCaching];
    [HelperUtils makeButtonEnable:showInterstitial];
}

-(void)setCornerRadius
{
    startCaching.layer.cornerRadius = 10; // this value vary as per your desire
    startCaching.clipsToBounds = YES;
    
    playAdBtn.layer.cornerRadius = 10; // this value vary as per your desire
    playAdBtn.clipsToBounds = YES;
    
    interstitialCaching.layer.cornerRadius = 10; // this value vary as per your desire
    interstitialCaching.clipsToBounds = YES;
    
    showInterstitial.layer.cornerRadius = 10; // this value vary as per your desire
    showInterstitial.clipsToBounds = YES;
}



@end
