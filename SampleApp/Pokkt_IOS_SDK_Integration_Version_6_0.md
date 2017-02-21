##Pokkt iOS SDK Integration Guide



1. Go to your project’s settings’s “Build Phases -> Link Binary with Libraries and



	`<key>NSAppTransportSecurity</key>`<br>
	`<dict>`<br>
`<key>pokkt.com</key>`<br>
`<true/>`<br>
`<key>NSExceptionAllowsInsecureHTTPLoads</key>`<br>
`<true/>`<br>
`<false/>`<br>
`<key>NSExceptionMinimumTLSVersion</key>`<br>`
<string>TLSv1.2</string>`<br>
`<key>NSThirdPartyExceptionAllowsInsecureHTTPLoads</key>`<br>
`<false/>`<br>
`<string>TLSv1.2</string>`<br>
`<false/>`<br>
`</dict>`<br>

4. Your Project needs to have following frameworks to use PokktSDK

	


	`Header -> Targets -> Capabilities -> Background Modes` <br>
	`-> Enable Background fetch`

			`UIApplicationBackgroundFetchIntervalMinimum];`


7. Need to implement the background fetch delegate methods in AppDelegate class


			`(void (^)(UIBackgroundFetchResult))completionHandle`

8. Import the PokktAds Class in AppDelegate. Then You will have to call the callBackgroundTaskCompletionHandler: method from performFetchWithCompletionHandler: Method.

	`performFetchWithCompletionHandler:`<br>
	`(void (^) (UIBackgroundFetchResult))completionHandler`
	`{`<br>
						`^(UIBackgroundFetchResult result)`<br>
	 	`{`<br>


	`settingsForTypes:(UIRemoteNotificationTypeBadge|`<br>




	`- (void)application:(UIApplication *)application` `didReceiveLocalNotification:(UILocalNotification *)notification`


11.  You will have to call the inAppNotificationEvent Method, When user tap on local notification.


 
	
















	**[PokktVideoAds cacheRewardedVideoAd: (NSString*)screenName];** 
	to start caching rewarded video ads on device.
	






  **[PokktInterstitial cacheRewardedInterstitial: (NSString*)screenName];**  to start caching rewarded interstitial ads on device.
  



to check if the campaign are available for nonrewarded interstitial for the screen name before you try to show ad.








3. Developer can provide these details by calling the method    **[PokktAds setPokktAnalyticsDetail: (PokktAnalyticsDetails *)analyticsDetail]**.



