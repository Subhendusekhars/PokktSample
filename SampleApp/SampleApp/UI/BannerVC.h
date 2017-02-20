//
//  BannerVC.h
//  SampleApp
//
//  Created by Pokkt on 31/08/16.
//  Copyright © 2016 Pokkt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PokktSDK/PokktSDK.h"

@interface BannerVC : UIViewController<BannerDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *screenTF;
   
    IBOutlet UIButton *showBanner1;
    IBOutlet UIButton *destroyBanner1;
    IBOutlet UIButton *showBanner2;
    IBOutlet UIButton *destroyBanner2;
    IBOutlet UIButton *nextScreenBanner;
    
    IBOutlet UILabel *versionLbl;
}
@end
