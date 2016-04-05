//
//  MainViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <CloudKit/CloudKit.h>
#import <SVProgressHUD.h>

#import "Post.h"
#import "MainViewController.h"
#import "SettingsViewController.h"
#import "NewPostViewController.h"
#import "MainViewController+UICollectionView.h"


@interface MainViewController()

@property (nonatomic, strong, readwrite) LSUser* user;
@end

@implementation MainViewController

#pragma mark - Root

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;

    self.user = [[LSUser alloc] init];
    
    self.results = [Post allObjects];
    NSLog(@"%@", self.results);
    
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
