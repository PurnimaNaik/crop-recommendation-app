//
//  AppDelegate.m
//  CropReco
//
//  Created by Purnima Naik on 8/4/19.
//  Copyright © 2019 Purnima Naik. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    UITabBarController *tabBar = (UITabBarController *)self.window.rootViewController;
    tabBar.selectedIndex = 1;
    
    [[tabBar.viewControllers objectAtIndex:0] tabBarItem].image=[[UIImage imageNamed:@"weatherTabIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[tabBar.viewControllers objectAtIndex:1] tabBarItem].image=[[UIImage imageNamed:@"recommendationTabIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [[tabBar.viewControllers objectAtIndex:2] tabBarItem].image=[[UIImage imageNamed:@"cropListBarIcon"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    
//    [[UITabBarItem appearance] setTitleTextAttributes:@{NSFontAttributeName: [UIFont fontWithName:@"Optima" size:11.0f]
//    } forState:UIControlStateNormal];
    
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Optima" size:11.f ],  NSFontAttributeName, nil] forState:UIControlStateNormal];
//
//    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Optima" size:11.f ], NSFontAttributeName, nil] forState:UIControlStateSelected];
    
[[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Optima" size:11.f ], NSFontAttributeName, [UIColor grayColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];
    
    [[UITabBarItem appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont fontWithName:@"Optima" size:11.f ], NSFontAttributeName, [UIColor blackColor], NSForegroundColorAttributeName,nil] forState:UIControlStateSelected];
    
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
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
