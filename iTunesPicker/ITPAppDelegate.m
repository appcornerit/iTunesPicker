//
//  ITPAppDelegate.m
//  iTunesPicker
//
//  Created by Denis Berton on 17/02/14.
//  Copyright (c) 2014 appcorner.it. All rights reserved.
//

#import "ITPAppDelegate.h"
#import "ITPViewController.h"
#import "ITPSideRightMenuViewController.h"

#import "JASidePanelController.h"
//#import "DCIntrospect.h"

@interface ITPAppDelegate()

@end



@implementation ITPAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    
#if TARGET_IPHONE_SIMULATOR
//    [[DCIntrospect sharedIntrospector] start];
#endif
    
    NSArray *types = [[NSUserDefaults standardUserDefaults] arrayForKey:DEFAULT_ACK_TYPES_KEY];
    if(!types || !REMOTE_CONFIGURATION_ENABLE)
    {
        types = DEFAULT_ACK_TYPES;
        [[NSUserDefaults standardUserDefaults] setObject:types forKey:DEFAULT_ACK_TYPES_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    if(REMOTE_CONFIGURATION_ENABLE)
    {
        [[ACKITunesQuery new] loadRemoteConfigurationFromURL:[NSURL URLWithString:REMOTE_CONFIGURATION_SERVER_URL] success:^(NSDictionary *defaults) {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_CHECK_ACK_TYPES object:nil];
        } failure:nil];
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
