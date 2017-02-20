//
//  AppDelegate.m
//  PokktManager
//
//  Created by Pokkt on 2/27/15.
//  Copyright (c) 2015 Pokkt. All rights reserved.
//

#import "AppDelegate.h"
#import <sys/utsname.h>
#import "PokktSDK/PokktSDK.h"
#import "HomeVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate
@synthesize navVC;

NSString* machinePokktName()
{
    struct utsname systemInfo;
    uname(&systemInfo);
    
    return [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
 }

- (void)checkDeviceType {
    if([machinePokktName() isEqualToString:@"iPhone4,1"])
    {
        _deviceType = iPhone4s;
    }
    else if([machinePokktName() isEqualToString:@"iPhone5,1"])
    {
        _deviceType = iPhone5;
    }
    else if([machinePokktName() isEqualToString:@"iPhone5,2"])
    {
        _deviceType = iPhone5;
    }
    else if([machinePokktName() isEqualToString:@"iPhone5,3"])
    {
        _deviceType = iPhone5;
    }
    else if([machinePokktName() isEqualToString:@"iPhone5,4"])
    {
        _deviceType = iPhone5;
    }
    else if([machinePokktName() isEqualToString:@"iPhone6,1"])
    {
        _deviceType = iPhone5;
    }
    else if([machinePokktName() isEqualToString:@"iPhone6,2"])
    {
        _deviceType = iPhone5;
    }
    else if([machinePokktName() isEqualToString:@"iPhone7,1"])
    {
        _deviceType = iPhone6;
    }
    else if([machinePokktName() isEqualToString:@"iPhone7,2"])
    {
        _deviceType = iPhone6Plus;
    }else{
        _deviceType = iPad;
    }
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [application setMinimumBackgroundFetchInterval:UIApplicationBackgroundFetchIntervalMinimum];
    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:(UIRemoteNotificationTypeBadge|
                                                                                         UIRemoteNotificationTypeSound|
                                                                                         UIRemoteNotificationTypeAlert)
                                                                             categories:nil];
   // [application registerUserNotificationSettings:settings];

//    
//    if ([UIApplication instancesRespondToSelector:@selector(registerUserNotificationSettings:)]){
//        [application registerUserNotificationSettings:[UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert|UIUserNotificationTypeBadge|UIUserNotificationTypeSound categories:nil]];
//    }
    
    [PokktManager setupNotification:@selector(registerUserNotificationSettings:) application:application];
    
       // Override point for customization after application launch.
    [self checkDeviceType];
 
//    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
//    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    HomeVC *home = [[HomeVC alloc] initWithNibName:@"HomeVC" bundle:nil];
    self.navVC = [[UINavigationController alloc] initWithRootViewController:home];
    self.navVC.navigationController.navigationBar.translucent = YES;
    if([UIDevice currentDevice].systemVersion.floatValue >= 8.0) {
        
        [[UINavigationBar appearance] setTranslucent:NO];
    }
    application.statusBarHidden = YES;
    [self.window setRootViewController:self.navVC];
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
        
 __block UIBackgroundTaskIdentifier   bgTask = [application beginBackgroundTaskWithName:@"MyTask" expirationHandler:^{
        // Clean up any unfinished task business by marking where you
        // stopped or ending the task outright.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    }];
    
    // Start the long-running task and return immediately.
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        // Do the work associated with the task, preferably in chunks.
        [application endBackgroundTask:bgTask];
        bgTask = UIBackgroundTaskInvalid;
    });
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification
{
    
    [PokktManager inAppNotificationEvent:notification];

}

-(void)application:(UIApplication *)application performFetchWithCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler{
    [PokktManager callBackgroundTaskCompletedHandler:^(UIBackgroundFetchResult result) {
        NSLog(@"%d",result);
    }];
    
}

-(BOOL)application:(UIApplication *)application
           openURL:(NSURL *)url
 sourceApplication:(NSString *)sourceApplication
        annotation:(id)annotation
{
    return YES;
}


@end
