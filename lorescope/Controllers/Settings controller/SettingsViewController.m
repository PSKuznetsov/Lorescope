//
//  SettingsViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 30/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController () <UITableViewDataSource, UITableViewDelegate>

@end

@implementation SettingsViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString* cellIdentifier = @"settingsCell";
    
    UITableViewCell* settingsCell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!settingsCell) {
        
        settingsCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1
                                              reuseIdentifier:cellIdentifier];
    }
    
    return settingsCell;
}

#pragma mark - Actions

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
