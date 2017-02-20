//
//  BannerVC.m
//  SampleApp
//
//  Created by Pokkt on 31/08/16.
//  Copyright © 2016 Pokkt. All rights reserved.
//

#import "BannerVC.h"
#import "HelperUtils.h"
#import "ProgressHud.h"
#import "BannerVC2.h"

@interface BannerVC ()

@end

@implementation BannerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self setButtonState];
    [self setUpNavigationBar];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(showToast:)
                                                 name:@"toastMessage1"
                                               object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    versionLbl.text = [NSString stringWithFormat:@"v%@",[PokktManager getSDKVersion]];
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

    label.text = @"Banner Ad";
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
    UIView *view = [self.view viewWithTag:1001];
    if (view != nil)
    {
        [PokktManager destroyBanner:view];
    }
    
    UIView *view2 = [self.view viewWithTag:2001];
    if (view2 != nil)
    {
        [PokktManager destroyBanner:view2];
    }
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setButtonState
{
    [HelperUtils makeButtonEnable:showBanner1];
    [HelperUtils makeButtonEnable:showBanner2];
    [HelperUtils makeButtonEnable:destroyBanner1];
    [HelperUtils makeButtonEnable:destroyBanner2];
    [HelperUtils makeButtonEnable:nextScreenBanner];
}


-(IBAction)showBannerNextScreen:(id)sender
{
    UIView *view = [self.view viewWithTag:1001];
    if (view != nil)
    {
        [PokktManager destroyBanner:view];
    }
    
    UIView *view2 = [self.view viewWithTag:2001];
    if (view2 != nil)
    {
        [PokktManager destroyBanner:view2];
    }

    BannerVC2 *banner2= [[BannerVC2 alloc] initWithNibName:@"BannerVC2" bundle:nil];
    [self.navigationController pushViewController:banner2 animated:YES];
}

-(IBAction)showBanner1:(id)sender
{
    if (screenTF.text.length > 0)
    {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
            view.tag = 1001;
            [view setBackgroundColor:[UIColor lightGrayColor]];
            [self.view addSubview:view];

            [PokktManager setBannerDelegate:self];
            [PokktManager setBannerAutoRefresh:true];
            [PokktManager loadBanner:screenTF.text bannerView:view withViewController:self];
    }
    else
    {
      [HelperUtils showAlertWithMessage:@"Please enter banner screenname"];
    }

}

-(IBAction)showBanner2:(id)sender
{
    if (screenTF.text.length > 0)
    {
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 55, [[UIScreen mainScreen] bounds].size.width, 50)];
            view.tag = 2001;
            [view setBackgroundColor:[UIColor lightGrayColor]];
            [self.view addSubview:view];
            [PokktManager setBannerAutoRefresh:true];
            [PokktManager loadBanner:screenTF.text bannerView:view withViewController:self];
    }
    else
    {
        [HelperUtils showAlertWithMessage:@"Please enter banner screenname"];
    }
    
}

-(IBAction)destroyBanner1:(id)sender
{
    UIView *view = [self.view viewWithTag:1001];
    if (view != nil)
    {
        [PokktManager destroyBanner:view];
    }
    
}

-(IBAction)destroyBanner2:(id)sender
{
    UIView *view = [self.view viewWithTag:2001];
    if (view != nil)
    {
        [PokktManager destroyBanner:view];
    }
    
}


#pragma mark Banner Delegates

- (void)onBannerLoaded:(NSString *)screenName
{
    [ProgressHUD dismiss];
    NSLog(@"%@",[NSString stringWithFormat:@"[BannerVC Class] Banner Loaded successfully with screenName %@",screenName]);
}

- (void)onBannerLoadFailed:(NSString *)screenName errorMessage:(NSString *)errorMessage
{
    [ProgressHUD showSuccess:@"Loading Failed"];
     NSLog(@"%@",[NSString stringWithFormat:@"[BannerVC Class] Banner Loaded failed with screenName %@ with errorMessage %@",screenName,errorMessage]);
}

-(void)showToast:(NSNotification *)note
{
    NSString *message = note.object;
    
    if (message != nil && message.length > 0)
    {
        [PokktManager showToast:message viewController:self];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

@end
