//
//  SettingsViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 30/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "SettingsViewController.h"

@implementation SettingsViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - Actions

    ///Handle custom back button
- (IBAction)backButton:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
    ///Handle logout button
- (IBAction)logout:(id)sender {
    
}

@end
