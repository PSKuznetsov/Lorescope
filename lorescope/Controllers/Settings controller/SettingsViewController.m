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
    
    self.userAvatar.layer.masksToBounds = YES;
    [self.userAvatar.layer setCornerRadius:self.userAvatar.frame.size.height / 2];
}

#pragma mark - Actions

    ///Handle custom back button
- (IBAction)backButton:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
