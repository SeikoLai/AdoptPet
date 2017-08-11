//
//  AppDelegate.m
//  AdoptPetInTaipei
//
//  Created by Sam on 03/07/2017.
//  Copyright © 2017 Hiiir. All rights reserved.
//

#import "AppDelegate.h"
@import GoogleMaps;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    NSLog(@"Current identifier: %@", [[NSBundle mainBundle] bundleIdentifier]);
    [GMSServices provideAPIKey:GoogleMapsSDKForiOSKey];
    [self updateAction];
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [self updateAction];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)updateAction
{
    if ([self needsUpdateVersion]) {
        [self showUpdateAlert];
    }
}

- (void)showUpdateAlert
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"【重大更新】" message:@"非常抱歉，由於有重要的資訊必須更新，請點擊更新按鈕，轉導至 App Stroe 更新，造成不變敬請見諒，謝謝。" preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"更新" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        NSString *iTunesLink = @"itms-apps://itunes.apple.com/tw/app/apple-store/id1262902815?mt=8";
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
    }]];
    [self.window.rootViewController presentViewController:alertController animated:YES completion:nil];
}

- (BOOL)needsUpdateVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString *appID = infoDictionary[@"CFBundleIdentifier"];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://itunes.apple.com/lookup?bundleId=%@", appID]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if (data.length) {
        NSDictionary *lookup = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (lookup[@"resultCount"] && [lookup[@"resultCount"] integerValue] == 1) {
            NSString *appStoreVersion = lookup[@"results"][0][@"version"];
            NSString *currentVersion = infoDictionary[@"CFBundleShortVersionString"];
            NSArray *appStroeVersionComponents = [appStoreVersion componentsSeparatedByString:@"."];
            NSArray *currentVersionComponents = [currentVersion componentsSeparatedByString:@"."];
            if (appStroeVersionComponents.count && currentVersionComponents.count) {
                if ([[appStroeVersionComponents[0] description] integerValue] > [[currentVersionComponents[0] description] integerValue]) {
                    return YES;
                }
                else if ([[appStroeVersionComponents[1] description] integerValue] > [[currentVersionComponents[1] description] integerValue]) {
                    return YES;
                }
            }
        }
    }
    return NO;
}
@end
