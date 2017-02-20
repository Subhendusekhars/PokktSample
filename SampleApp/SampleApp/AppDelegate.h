//
//  AppDelegate.h
//  PokktManager
//
//  Created by Pokkt on 2/27/15.
//  Copyright (c) 2015 Pokkt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    iPhone4s,
    iPhone5,
    iPhone5s,
    iPhone6,
    iPhone6Plus,
    iPad
} DeviceType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic) DeviceType deviceType;
@property(nonatomic,retain)UINavigationController *navVC;


@end

