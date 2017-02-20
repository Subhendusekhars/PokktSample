//
//  BannerVC2.m
//  SampleApp
//
//  Created by Pokkt on 15/09/16.
//  Copyright © 2016 Pokkt. All rights reserved.
//

#import "BannerVC2.h"
#import "HelperUtils.h"

@interface BannerVC2 ()

@end

@implementation BannerVC2

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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

-(void)setButtonState
{
    [HelperUtils makeButtonEnable:showBanner];
    [HelperUtils makeButtonEnable:destroyBanner];
}

-(IBAction)backAction:(id)sender
{
    UIView *view = [self.view viewWithTag:3001];
    if (view != nil)
    {
        [PokktManager destroyBanner:view];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)showBanner:(id)sender
{
    if (screenTF.text.length > 0)
    {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [[UIScreen mainScreen] bounds].size.width, 50)];
        view.tag = 3001;
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

-(IBAction)destroyBanner:(id)sender
{
    UIView *view = [self.view viewWithTag:3001];
    if (view != nil)
    {
        [PokktManager destroyBanner:view];
    }
    
}

#pragma mark Banner Delegates

- (void)onBannerLoaded:(NSString *)screenName
{
    NSLog(@"%@",[NSString stringWithFormat:@"[BannerVC Class] Banner Loaded successfully with screenName %@",screenName]);
}

- (void)onBannerLoadFailed:(NSString *)screenName errorMessage:(NSString *)errorMessage
{
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
