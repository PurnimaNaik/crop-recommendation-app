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
    tabBar.selectedIndex = 2;
    
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

}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
