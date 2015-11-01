//
//  MainViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "MainViewController.h"
#import "SettingsViewController.h"
#import "MainViewController+UICollectionView.h"

@interface MainViewController()

@end

@implementation MainViewController

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
}

#pragma mark - Actions

- (IBAction)newPostButton:(id)sender {
    
}

- (IBAction)settingsButton:(id)sender {
    
    SettingsViewController* settingsController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsController animated:YES];
}

@end
