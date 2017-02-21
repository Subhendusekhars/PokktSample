##Pokkt iOS SDK Integration Guide
####1. Steps to Add PokktSDK


1. Go to your project’s settings’s “Build Phases -> Link Binary with Libraries andadd the PokktSDK.framework and ComScore.framework
2. Make sure to add PokktSDK.bundle file to application
3. Please add following exceptions in your application info.plist file(please edit assource for this.)

	`<key>NSAppTransportSecurity</key>`<br>
	`<dict>`<br>`<key>NSExceptionDomains</key>`<br>`<dict>`<br>
`<key>pokkt.com</key>`<br>`<dict>`<br>`<key>NSIncludesSubdomains</key>`<br>
`<true/>`<br>
`<key>NSExceptionAllowsInsecureHTTPLoads</key>`<br>
`<true/>`<br>`<key>NSExceptionRequiresForwardSecrecy</key>`<br>
`<false/>`<br>
`<key>NSExceptionMinimumTLSVersion</key>`<br>`
<string>TLSv1.2</string>`<br>
`<key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>`<br>
`<false/>`<br>`<key>NSThirdPartyExceptionRequiresForwardSecrecy</key><true/>`<br>`<key>NSThirdPartyExceptionMinimumTLSVersion</key>`<br>
`<string>TLSv1.2</string>`<br>`<key>NSRequiresCertificateTransparency</key>`<br> 
`<false/>`<br>
`</dict>`<br>`<key>cloudfront.net</key>`<br>`<dict>`<br>`<key>NSIncludesSubdomains</key>`<br>`<true/>`<br>`<key>NSExceptionAllowsInsecureHTTPLoads</key>`<br>`<true/>`<br>`<key>NSExceptionRequiresForwardSecrecy</key>`<br>`<false/>`<br>`<key>NSExceptionMinimumTLSVersion</key>`<br>`<string>TLSv1.2</string>`<br>`<key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>`<br>`<false/>`<br>`<key>NSThirdPartyExceptionRequiresForwardSecrecy</key>`<br>`<true/>`<br>`<key>NSThirdPartyExceptionMinimumTLSVersion</key>`<br>`<string>TLSv1.2</string>`<br>`<key>NSRequiresCertificateTransparency</key>`<br>`<false/>`<br>`</dict>`<br>`</dict>`<br>`</dict>`<br>

4. Your Project needs to have following frameworks to use PokktSDK	- CoreData.framework	- Foundation.framework	- MediaPlayer.framework	- SystemConfiguration.framework	- UIKit.framework	- CoreTelephony.framework	- EventKit.framework	- AdSupport.framework	- CoreGraphics.framework	- CoreMotion.framework	- MessageUI.framework	- EventKitUI.framework	- CoreLocation.framework	- AVFoundation.framework	- libc++.tbd

	5. Please make sure that your app project has -ObjC set as Other linker flag in Build Settings.
6. Need to enabled background fetch mode in Xcode for PokktSDK background fetch Project 

	`Header -> Targets -> Capabilities -> Background Modes` <br>
	`-> Enable Background fetch`
	`[application setMinimumBackgroundFetchInterval:` <br>
			`UIApplicationBackgroundFetchIntervalMinimum];`
	(Write this in DidFinishLaunchWithOption delegate method)

7. Need to implement the background fetch delegate methods in AppDelegate class

	`-(void)application:(UIApplication *)application` 				`performFetchWithCompletionHandler:` 
			`(void (^)(UIBackgroundFetchResult))completionHandle`

8. Import the PokktAds Class in AppDelegate. Then You will have to call the callBackgroundTaskCompletionHandler: method from performFetchWithCompletionHandler: Method.
	`- (void)application:(UIApplication *)application`<br>
	`performFetchWithCompletionHandler:`<br>
	`(void (^) (UIBackgroundFetchResult))completionHandler`
	`{`<br>	`[PokktAds callBackgroundTaskCompletionHandler:` <br>
						`^(UIBackgroundFetchResult result)`<br>
	 	`{`<br>		`completionHandler(result);`<br>	`}];`<br>	`}`
9. Enable the local notification for InApp Notifications in AppDelegate class.
	`UIUserNotificationSettings *settings = [UIUserNotificationSettings` <br>
	`settingsForTypes:(UIRemoteNotificationTypeBadge|`<br>`UIRemoteNotificationTypeSound|UIRemoteNotificationTypeAlert)`<br> `categories:nil];`<br>`[application registerUserNotificationSettings:settings];`<br>
	Note: Write this lines in DidFinishLaunchingWithOptions: delegate method in app delegate class

10. Implement LocalNotification delegate method in AppDelegate Class

	`- (void)application:(UIApplication *)application` `didReceiveLocalNotification:(UILocalNotification *)notification`


11.  You will have to call the inAppNotificationEvent Method, When user tap on local notification.
	`- (void)application:(UIApplication *)application`<br> `didReceiveLocalNotification:`<br>`(UILocalNotification *) notification`<br>`{`<br>`[PokktAds inAppNotificationEvent:notification];`<br>`}`
14. PokktAds class provide the LogExport method to get log file.
 	`+ (void) exportLog:(UIViewController *)viewController`
	15. You will have to call the notifyAppInstall method, When application launch first.	`+ (void) notifyAppInstall`
###2. Implementation Steps####• Common1. For all invocation of Pokkt SDK developer will make use of methods available in PokktAds class.This class only have static methods.
2. You will have to implement the PokktVideoDelegates protocol in your class to listen for all Video ad related events.
3. You will have to implement the PokktInterstitialDelegates protocol in your class to listen for all Interstitial related events.
4. You will have to implement the PokktBannerDelegate protocol in your class to listen for all banner related events.
5. Before calling any other methods from the PokktAds please make sure that you have called the **setPokktConfigWithAppId:(NSString*) appIdsecurityKey:(NSString*) securityKey** already (This does not apply tosession related methods namely startSession and endSession).
6. If you are doing server to server integration with pokkt you can also **setThirdPartyUserId** by calling setThirdPartyUserId:(NSString*) userId .
7. Apart from above mentioned parameters you can assign additional ones based on your integration type.(please refer to Ad sections below.)
8. While in development please call **[PokktDebugger setDebug:YES];** to see pokkt debug logs and toast messages. please make sure to change this to **[PokktDebugger setDebug:NO];** for production build.
9. Please call **[PokktAds trackIAP: InAppPurchaseDetails]** to send any in-app purchase information to Pokkt.####• PokktAdPlayerViewConfig1. In PokktAdPlayerViewConfig you can assign **defaultSkipTime**,**skipConfirmMessage**, **shouldAllowMute**, **shouldSkipConfirm**,**skipConfirmYesLabel**, **skipConfirmNoLabel**, **skipTimerMessage**, **shouldCollectFeedback** and**incentiveMessage** . These values can be used to configure the behaviour ofad.2. If you want to enable/disable the skip button on video screen please set shouldAllowSkip as true/false.The default value for shouldAllowSkip is true.
3. If you have enabled skipped button by setting shouldAllowSkip as true then you can control after how many seconds the skip button will be visible in video by setting defaultSkipTime to appropriate value.Since most videos will be 30 sec or less please set defaultSkipTime as 10 or less.You can also give yourown skip message by setting skipConfirmMessage on AdPlayerViewConfig
4. You can configure the ad skip dialog yes/no labels by settingskipConfirmYesLabel and skipConfirmNoLabel.
5. You can configure the ad incentive message by setting incentiveMessage.
6. You can configure the ad skip timer message by setting skipTimerMessage. The message must contain a ## placeholder to show skip time value, which will keep changing as per the time.
####• Video Ads1. Before calling cache and show method you need to createPokktVideoAdsDelegate implementation class as mentioned in step 3 inimplementation steps. After that set videoAds delegate by calling**[PokktVideoAdsDelegate setPokktVideoAdsDelegate:];**
2. You will get different callbacks as given in PokktVideoAdsDelegateimplementation class for ad display and isRewarded value will come TRUE if it is a rewarded ad.
####• Video Ads (Rewarded)1. You will have to call 
	**[PokktVideoAds cacheRewardedVideoAd: (NSString*)screenName];** 
	to start caching rewarded video ads on device.
	2. You can call **[PokktVideoAds checkRewardedVideoAdAvailability: (NSString*)screenName** to check if the campaign are available for rewarded video for the screen name before you try to show ad.3. You can call **[PokktVideoAds showRewardedVideoAd:(NSString*)screenName viewController:(UIViewController *)viewController];** to showrewarded video Ad.
4. Please reward user from the videoAdGratified method inPokktVideoAdsDelegate implementation class.
####• Video Ads (Non-Rewarded)1. You will have to call **[PokktVideoAds cacheNonRewardedVideoAd:(NSString*) screenName];** to start caching nonrewarded video ads on device2. You can call **[PokktVideoAds checkNonRewardedVideoAdAvailability:(NSString*) screenNam**e to check if the campaign are available fornonrewarded video for the screen name before you try to show ad.
3. You can call **[PokktVideoAds showNonRewardedVideoAd:(NSString*)screenName viewController:(UIViewController *)viewController];** to show nonrewarded video Ad.
###• Interstitial1. Before calling cache and show method you need to createPokktInterstitialDelegate implementation class. After that set interstitial delegate by calling **[PokktInterstial setPokktInterstitialDelegate:];**.
2. You will get different callbacks as given in PokktInterstitialDelegate implementation class for ad display and isRewarded value will come TRUE if it is a rewarded ad.
###• Interstitial (Rewarded)1. You will have to call 
  **[PokktInterstitial cacheRewardedInterstitial: (NSString*)screenName];**  to start caching rewarded interstitial ads on device.
  2. You can call **[PokktInterstitial checkRewardedInterstitialAvailability:(NSString*) screenName** to check if the campaign are available for rewardedinterstitial for the screen name before you try to show ad.
3. You can call **[PokktInterstitial showRewardedInterstitial(NSString*)screenName viewController:(UIViewController *)viewController];** to show rewarded interstitial Ad.
4. Please reward user from the interstitialGratified method inPokktInterstitialDelegate implementation class.###• Interstitial (Non-Rewarded)1. You will have to call **[PokktInterstitial cacheNonRewardedInterstitial:(NSString*) screenName];** to start caching nonrewarded interstitial ads on device.
2. You can call **[PokktInterstitial checkNonRewardedInterstitialAvailability: (NSString*) screenName** 
to check if the campaign are available for nonrewarded interstitial for the screen name before you try to show ad.
3. You can call **[PokktInterstitial showNonRewardedInterstitial(NSString*) screenName viewController:(UIViewController *)viewController];** to show nonrewarded interstitial Ad.
###• PokktUserInfo
1. PokktUserConfig is used for developers to provide extra user data available with them to pokkt. We currently support following data points: **name, age, sex, mobileNo, emailAddress, location, birthday, maritalStatus, facebookId, twitterHandle, education, nationality, employment and maturityRating**.
2. Developer can provide these details by calling the method **[PokktAds setPokktUserDetails: (PokktUserInfo *)userInfo]**.
###• PokktAnalyticsDetail
1. PokktAnalyticsDetails is used for developers to provide multiple analytics trackers available with them to pokkt. Those are Google,Flurry and MixPanel. Which need the trackerID. Currently supported : googleTrackerID, flurryTrackerID andmixPanelTrackerID.
2. PokktAnalyticsDetails providing the eventype for the type of analytic used in application side . Which is eventType (Event types are provided in PokktAnalyticsDetails class only)

3. Developer can provide these details by calling the method    **[PokktAds setPokktAnalyticsDetail: (PokktAnalyticsDetails *)analyticsDetail]**.
###•Export Logs
1. Developer should call **[PokktDebugger exportLog: (UIVIewController*)controller** to export the Pokkt SDK logs to some folder.
2. This API shows a folder chooser dialog where user can choose a particular folder.
3. User can also create a new folder where user wants to export the logs