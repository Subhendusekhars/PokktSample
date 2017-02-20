//
//  BannerVC2.h
//  SampleApp
//
//  Created by Pokkt on 15/09/16.
//  Copyright © 2016 Pokkt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PokktSDK/PokktSDK.h"

@interface BannerVC2 : UIViewController<BannerDelegate,UITextFieldDelegate>
{
    IBOutlet UITextField *screenTF;
   
    IBOutlet UIButton *showBanner;
    IBOutlet UIButton *destroyBanner;
    
    IBOutlet UILabel *versionLbl;
}
@end
