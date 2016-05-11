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
#import "PreviewPostViewController.h"
#import "LSMainControllerFlowLayout.h"


static NSString * LSCellId = @"LSCell";

@interface MainViewController()
@property (nonatomic, strong, readwrite) LSUser* user;
@end

@implementation MainViewController

#pragma mark - Root

- (void)loadView {
    [super loadView];
    
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    self.collectionView.collectionViewLayout = [[LSMainControllerFlowLayout alloc]init];
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    
    self.user  = [[LSUser alloc] init];
    self.cache = [[NSMutableDictionary alloc]init];
    self.localManager = [[LSLocalPostManager alloc]init];
    
    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lorescope"]];
    self.navigationController.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - LSControllerManipulatorDelegate

- (void)contorllerShouldPerformReloadData:(UIViewController *)controller {
    [self.collectionView reloadData];
}

#pragma mark - Actions

- (IBAction)newPostButton:(id)sender {
    
    [self performSegueWithIdentifier:@"newPostSegue" sender:self];
}

- (IBAction)settingsButton:(id)sender {
    
    SettingsViewController* settingsController = [self.storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    [self.navigationController pushViewController:settingsController animated:YES];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"previewPostSegue"]) {
        
        PreviewPostViewController* destinationController = [segue destinationViewController];
        destinationController.localPost = self.loadedPost;
        destinationController.postImage = self.selectedImage;
    }
}

@end
