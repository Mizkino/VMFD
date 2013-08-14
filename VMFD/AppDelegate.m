//
//  AppDelegate.m
//  VMFD
//
//  Created by pcuser on 2013/08/08.
//  Copyright (c) 2013年 pcuser. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "RecordViewController.h"
#import "ListViewController.h"
#import "DataManager.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //@@@@
    [[DataManager sharedManager] load];
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MainViewController *menCon = [MainViewController new];
    RecordViewController *recCon = [RecordViewController new];
    ListViewController *lisCon = [ListViewController new];

//    MainViewController *controller = [MainViewController new];
//    RecordViewController *reccon = [RecordViewController new];
//    ListViewController *liscon = [ListViewController new];
    //reccon.title = @"Rec";
    [recCon.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"Button.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"Button.png"]];
    lisCon.title = @"List";
    [lisCon.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"List.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"List.png"]];
    //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    //self.window.rootViewController = navController;
    
    UITabBarController *tabcon = [UITabBarController new];
    [tabcon setViewControllers:@[menCon,recCon,lisCon]];
    self.window.rootViewController = tabcon;
    
    //initArray that contains viewControllers
//    NSMutableArray *viewControllers = [NSMutableArray array];
//    //init views
//
//    //set on Navicon
//    UINavigationController *menNav = [[UINavigationController alloc]initWithRootViewController:menCon];
//    [menNav setNavigationBarHidden:YES];
//    [viewControllers addObject:menNav];
//    
//    UINavigationController *recNav = [[UINavigationController alloc]initWithRootViewController:recCon];
//    [recNav setNavigationBarHidden:YES];
//    [viewControllers addObject:recNav];
//    
//    UINavigationController *lisNav = [[UINavigationController alloc]initWithRootViewController:lisCon];
//    [lisNav setNavigationBarHidden:YES];
//    [viewControllers addObject:lisNav];
//    
//    self.tabBarController = [UITabBarController new];
//    [self.tabBarController setViewControllers:viewControllers];
//    self.window.rootViewController = self.tabBarController;
    
//    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    [[DataManager sharedManager] save];
    
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
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
