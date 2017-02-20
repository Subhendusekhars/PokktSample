//
//  TestRewardedVC.h
//  SampleApp
//
//  Created by Pokkt on 17/02/16.
//  Copyright © 2016 Pokkt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "PokktSDK/PokktSDK.h"
#import "PokktSDK/PokktConfig.h"
#import "PokktSDK/AdConfig.h"


@interface TestRewardedVC : UIViewController <AdDelegate,PokktInitDelegate>
{
    IBOutlet UIScrollView *scroll;
    IBOutlet UIButton *startCaching;
    IBOutlet UIButton *playAdBtn;
    IBOutlet UIButton *interstitialCaching;
    IBOutlet UIButton *showInterstitial;
    
    IBOutlet UILabel *versionLbl;

    
}
@property (weak, nonatomic) IBOutlet UILabel *pointNumLbl;

@property (nonatomic, retain)  NSString *screenName;
@property (nonatomic, strong) AdConfig *adConfig;
@property (nonatomic, strong) AdConfig *adConfigInterstitial;
@property (nonatomic) BOOL isRewardedScreen;
@end
