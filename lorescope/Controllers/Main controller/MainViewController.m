    //
    //  MainViewController.m
    //  lorescope
    //
    //  Created by Paul Kuznetsov on 18/10/15.
    //  Copyright © 2015 Paul Kuznetsov. All rights reserved.
    //

#import "MainViewController.h"

#import <ZOZolaZoomTransition.h>
#import <CloudKit/CloudKit.h>
#import <SVProgressHUD.h>

#import "LSLocalPostManagerProtocol.h"
#import "LSDataSynchronizerProtocol.h"
#import "LSDataSynchronizer.h"
#import "LSImageManagerProtocol.h"
#import "LSImageManager.h"

#import "LSUser.h"

#import "LSLocalPost.h"
#import "LSLocalPostManager.h"

#import "SettingsViewController.h"
#import "NewPostViewController.h"
#import "PreviewPostViewController.h"
#import "LSMainControllerFlowLayout.h"


static NSString * LSCellId = @"LSCell";

@interface MainViewController() <UICollectionViewDelegate, UICollectionViewDataSource,
UICollectionViewDelegateFlowLayout, ZOZolaZoomTransitionDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) LSUser* user;

@end

@implementation MainViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self configureCollectionView:self.collectionView];
    [self configureDependencies];
    
    [SVProgressHUD show];
    [self.synchronizer shouldConnectWithUser:self.user completionHandler:^(BOOL success, NSError *error) {
        if (success) {
            [SVProgressHUD dismiss];
        }
        else {
            [SVProgressHUD showErrorWithStatus:[NSString stringWithFormat:@"%@", error.localizedDescription]];
        }
    }];
}

- (void)loadView {
    [super loadView];
    
    self.imageManager = [[LSImageManager alloc]init];

    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Lorescope"]];
    self.navigationController.delegate = self;
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

#pragma mark - LSControllerManipulatorDelegate

- (void)contorllerShouldPerformReloadData:(UIViewController *)controller {
    NSLog(@"Reloading data!");
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

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    [self.localManager updatePostsCount];
    return [self.localManager postsCount];
}

    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PostCollectionViewCell *postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCellID"
                                                                                 forIndexPath:indexPath];
    
    postCell.layer.shouldRasterize = YES;
    postCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    postCell.imageView.image = nil;
        //TODO: make image request on the background queue
    
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString* imagePath  = [self imagePathFromDBWithIndex:indexPath.row];
        UIImage* requestedImage = [self.imageManager imageFromDocumentsDirectoryWithName:imagePath];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            PostCollectionViewCell *updatedPostCell = (PostCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            updatedPostCell.imageView.alpha = 0.0;
            
            if (updatedPostCell) {
                [UIView animateWithDuration:0.3f animations:^{
                    updatedPostCell.imageView.image = requestedImage;
                    [updatedPostCell.imageView setAlpha:1.0];
                }];
            }
        });
    });
    
    return postCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __weak typeof(self) weakSelf = self;
    
    self.selectedCell  = (PostCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    self.selectedImage = self.selectedCell.imageView.image;
    
    [self.localManager postWithIndexInDB:indexPath.row
                       completionHandler:^(id<LSLocalPostProtocol> post, NSError *error) {
                           
                           typeof(self) strongSelf = weakSelf;
                           
                           if (!error) {
                               
                               strongSelf.loadedPost = post;
                               
                               [strongSelf performSegueWithIdentifier:@"previewPostSegue" sender:self];
                           }
                       }];
    
}

#pragma mark - UINavigationControllerDelegate

- (id <UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                   animationControllerForOperation:(UINavigationControllerOperation)operation
                                                fromViewController:(UIViewController *)fromVC
                                                  toViewController:(UIViewController *)toVC {
    
    if ([toVC isKindOfClass:[PreviewPostViewController class]] || [fromVC isKindOfClass:[PreviewPostViewController class]]) {
        
            // Determine if we're presenting or dismissing
        ZOTransitionType type = (fromVC == self) ? ZOTransitionTypePresenting : ZOTransitionTypeDismissing;
        
            // Create a transition instance with the selected cell's imageView as the target view
        ZOZolaZoomTransition *zoomTransition = [ZOZolaZoomTransition transitionFromView:self.selectedCell.imageView
                                                                                   type:type
                                                                               duration:0.3
                                                                               delegate:self];
        zoomTransition.fadeColor = [UIColor colorWithWhite:0.97 alpha:1.0];
        
        return zoomTransition;
    }
    
    return nil;
}

#pragma mark - ZOZolaZoomTransitionDelegate

- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
        startingFrameForView:(UIView *)targetView
              relativeToView:(UIView *)relativeView
          fromViewController:(UIViewController *)fromViewController
            toViewController:(UIViewController *)toViewController {
    
    if (fromViewController == self) {
            // We're pushing to the detail controller. The starting frame is taken from the selected cell's imageView.
        return [self.selectedCell.imageView convertRect:self.selectedCell.imageView.bounds toView:relativeView];
    } else if ([fromViewController isKindOfClass:[PreviewPostViewController class]]) {
            // We're popping back to this master controller. The starting frame is taken from the detailController's imageView.
        PreviewPostViewController *detailController = (PreviewPostViewController *)fromViewController;
        return [detailController.imageView convertRect:detailController.imageView.bounds toView:relativeView];
    }
    
    return CGRectZero;
}

- (CGRect)zolaZoomTransition:(ZOZolaZoomTransition *)zoomTransition
       finishingFrameForView:(UIView *)targetView
              relativeToView:(UIView *)relativeView
          fromViewController:(UIViewController *)fromViewComtroller
            toViewController:(UIViewController *)toViewController {
    
    if (fromViewComtroller == self) {
            // We're pushing to the detail controller. The finishing frame is taken from the detailController's imageView.
        PreviewPostViewController *detailController = (PreviewPostViewController *)toViewController;
        return [detailController.imageView convertRect:detailController.imageView.bounds toView:relativeView];
    } else if ([fromViewComtroller isKindOfClass:[PreviewPostViewController class]]) {
            // We're popping back to this master controller. The finishing frame is taken from the selected cell's imageView.
        return [self.selectedCell.imageView convertRect:self.selectedCell.imageView.bounds toView:relativeView];
    }
    
    return CGRectZero;
}

#pragma mark - Utils

- (NSString *)imagePathFromDBWithIndex:(NSUInteger)index {
    
    __block NSString* loadedPostPath;
    
    [self.localManager postWithIndexInDB:index
                       completionHandler:^(id<LSLocalPostProtocol> post, NSError *error) {
                           
                           if (!error) {
                               loadedPostPath = post.photoPath;
                           }
                       }];
    
    return loadedPostPath;
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@"previewPostSegue"]) {
        PreviewPostViewController* destinationController = [segue destinationViewController];
        destinationController.localPost = self.loadedPost;
        destinationController.postImage = self.selectedImage;
    }
}

#pragma mark - Utils

- (void)configureCollectionView:(UICollectionView *)collectionView {
    collectionView.collectionViewLayout = [[LSMainControllerFlowLayout alloc]init];
    collectionView.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
}

- (void)configureDependencies {
    self.user  = [[LSUser alloc]init];
    self.cache = [[NSMutableDictionary alloc]init];
    self.localManager = [[LSLocalPostManager alloc]init];
    self.synchronizer = [[LSDataSynchronizer alloc]init];
}

@end
