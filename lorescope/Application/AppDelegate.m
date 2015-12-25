//
//  AppDelegate.m
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//
#import <Parse.h>

#import "AppDelegate.h"
#import "LoginViewController.h"
#import "MainViewController.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [Parse enableLocalDatastore];
    
    
    [Parse setApplicationId:@"DZgpVjAZNFTjLQHDd3wyfBVJvLWgRiUxCgAJgw0v"
                  clientKey:@"V8aWhC1ggfEihMxRJk5S4W6Vp00yp2hhjNYVE70a"];
    
    // [Optional] Track statistics around application opens.
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];

    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ApplicationLaunchedOnce"]) {
        //First Launch of the app
    }
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"UserDidAuth"]) {
        //user is not login in
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        LoginViewController* loginViewController = [storyboard instantiateViewControllerWithIdentifier:@"LoginViewController"];
        
        self.window.rootViewController = loginViewController;
    }
    else {
        
        UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        MainViewController* mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
        UINavigationController* navController  = [[UINavigationController alloc] initWithRootViewController:mainViewController];
        navController.navigationBarHidden = YES;
        
        self.window.rootViewController = navController;
        
    }
    
    return YES;
}

@end
