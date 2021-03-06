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
UITabBarController *tabcon;
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //@@@@
    [[DataManager sharedManager] load];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    MainViewController *menCon = [MainViewController new];
    RecordViewController *recCon = [RecordViewController new];
    ListViewController *lisCon = [ListViewController new];
    
    menCon.title = @"Main";
    [menCon.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"home__.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"home_.png"]];
    [recCon.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"TabButton.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"TabButton.png"]];
    lisCon.title = @"List";
    [lisCon.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"list__.png"] withFinishedUnselectedImage:[UIImage imageNamed:@"list_.png"]];
    //UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:controller];
    //self.window.rootViewController = navController;
    
//UITabBarController *tabcon = [UITabBarController new];
    tabcon = [UITabBarController new];
    [tabcon setViewControllers:@[menCon,recCon,lisCon]];
    self.window.rootViewController = tabcon;
    [self.window makeKeyAndVisible];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    UIImage *buttonImage = [UIImage imageNamed:@"TabButton.png"];
//    button.frame = CGRectMake(0.0, 0.0,  buttonImage.size.width, buttonImage.size.height);
//    [button setBackgroundImage:buttonImage forState:UIControlStateNormal];
////    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
//        CGPoint center = tabcon.view.center;
//        center.y = tabcon.view.frame.size.height - (buttonImage.size.height*1/5);
//        button.center = center;
//    [tabcon.view addSubview:button];
//    [button addTarget:self.tabBarController action:@selector(centerButtonTouched)
//     forControlEvents:UIControlEventTouchUpInside];
    return YES;
    }
//-(void)centerButtonTouched{
//    [self.tabBarController setSelectedIndex:1];
//}

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
