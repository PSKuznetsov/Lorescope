//
//  AppDelegate.m
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import <CloudKit/CloudKit.h>

@interface AppDelegate ()
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ApplicationLaunchedOnce"]) {
        //TODO:First Launch of the app. Show user story
    }
    
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MainViewController* mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController* navController  = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    navController.navigationBarHidden = YES;

    self.window.rootViewController = navController;

    
//        //TODO: Fix for iCloud end user
//    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"UserDidAuth"]) {
//        //user is not login in
//        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        
//    } else {
//        
//        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        
//        MainViewController* mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//        UINavigationController* navController  = [[UINavigationController alloc] initWithRootViewController:mainViewController];
//        navController.navigationBarHidden = YES;
//        
//        self.window.rootViewController = navController;
//        
//    }
    
    return YES;
}

@end
