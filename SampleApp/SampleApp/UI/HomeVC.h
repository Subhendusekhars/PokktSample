//
//  HomeVC.h
//  SampleApp
//
//  Created by Pokkt on 16/02/16.
//  Copyright © 2016 Pokkt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeVC : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *screenNameTF;
    IBOutlet UITextField *appIdTF;
    IBOutlet UITextField *securityKeyTF;
    IBOutlet UIButton *testRewarded;
    IBOutlet UIButton *testNonRewarded;
    IBOutlet UIButton *settingBtn;
    IBOutlet UIButton *exportLog;
    IBOutlet UIButton *bannerBtn;
    IBOutlet UIButton *initializeSdkBtn;
    
    IBOutlet UIScrollView *scroll;
    
    IBOutlet UILabel *appIdLbl;
    IBOutlet UILabel *securityLbl;
    BOOL keyboardIsShown;
    BOOL isPokktInitialize;
    
    IBOutlet UILabel *versionLbl;
}

@end
