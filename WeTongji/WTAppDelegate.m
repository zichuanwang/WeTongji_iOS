//
//  WTAppDelegate.m
//  WeTongji
//
//  Created by 王 紫川 on 12-11-6.
//  Copyright (c) 2012年 Tongji Apple Club. All rights reserved.
//

#import "WTAppDelegate.h"
#import <WeTongjiSDK/WeTongjiSDK.h>
#import "WTCoreDataManager.h"
#import "UIApplication+WTAddition.h"

#define FLURRY_API_KEY @"SMBC9798JNZG6WQ7FDRJ"

@implementation WTAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    
    //[Flurry setDebugLogEnabled:YES];
    //[Flurry setShowErrorInLogEnabled:YES];
    [Flurry setAppVersion:[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [Flurry startSession:FLURRY_API_KEY];
    
    WTLOG(@"Current disk cache capacity:%d", [[NSURLCache sharedURLCache] diskCapacity] / 1024);
    WTLOG(@"Current memory cache capacity:%d", [[NSURLCache sharedURLCache] memoryCapacity] / 1024);
    WTLOG(@"Current disk cache usage:%d", [[NSURLCache sharedURLCache] currentDiskUsage] / 1024);
    WTLOG(@"Current memory cache usage:%d", [[NSURLCache sharedURLCache] currentMemoryUsage] / 1024);
    
    [UIApplication showTopCorner];
        
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
    [[WTCoreDataManager sharedManager] saveContext];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[WTCoreDataManager sharedManager] saveContext];
}

@end
