//
//  MainViewController+UICollectionView.m
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//


#import "MainViewController+UICollectionView.h"
#import "PreviewPostViewController.h"

@implementation MainViewController (UICollectionView)

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
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString* imagePath  = [self imagePathFromDBWithIndex:indexPath.row];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            PostCollectionViewCell *updatedPostCell = (PostCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            
            updatedPostCell.imageView.alpha = 0.0;
            
            if (updatedPostCell) {
                [self imageFromDocumentsDirectory:imagePath completionHandler:^(UIImage *image) {                    
                    [UIView animateWithDuration:0.3f animations:^{
                        updatedPostCell.imageView.image = image;
                        [updatedPostCell.imageView setAlpha:1.0];
                    }];
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

- (void)imageFromDocumentsDirectory:(NSString *)imagePath completionHandler:(void(^)(UIImage* image))handler {
    
    UIImage *image = [self.cache valueForKey:imagePath];
    if (image) {
        handler(image);
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:imagePath];
        
        NSData *pngData      = [[NSData alloc]initWithContentsOfFile:path];
        UIImage *loadedImage = [[UIImage alloc]initWithData:pngData];
        
            //redraw image using device context
        UIGraphicsBeginImageContextWithOptions(loadedImage.size, YES, 0);
        [loadedImage drawAtPoint:CGPointZero];
        loadedImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.cache setObject:loadedImage forKey:imagePath];
            handler(loadedImage);
        });
    });
}

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

@end
