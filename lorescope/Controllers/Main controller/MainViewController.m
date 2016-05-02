//
//  MainViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import <SVProgressHUD.h>

#import "LSLocalPost.h"
#import "LSLocalPostManager.h"

#import "MainViewController.h"
#import "MainViewController+UICollectionView.h"

#import "SettingsViewController.h"
#import "NewPostViewController.h"



@interface MainViewController()
@property (nonatomic, strong, readwrite) LSUser* user;
@end

@implementation MainViewController

#pragma mark - Root

- (void)loadView {
    [super loadView];
    
    self.user = [[LSUser alloc] init];
    self.cache = [[NSMutableDictionary alloc]init];
    self.localManager = [[LSLocalPostManager alloc]init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    [self.collectionView reloadData];
}

#pragma mark - Actions

- (IBAction)newPostButton:(id)sender {
    
    NewPostViewController* newPostController = [self.storyboard instantiateViewControllerWithIdentifier:@"NewPostViewController"];
    [self.navigationController pushViewController:newPostController animated:YES];
}

- (IBAction)settingsButton:(id)sender {
    
    SettingsViewController* settingsController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsController animated:YES];
}

@end
