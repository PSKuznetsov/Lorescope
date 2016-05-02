//
//  MainViewController+UICollectionView.m
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "MainViewController+UICollectionView.h"
#import "PreviewPostViewController.h"
#import "PostCollectionViewCell.h"

#import "LSLocalPost.h"

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
    postCell.postImage.image = nil;
    
    postCell.layer.shouldRasterize = YES;
    postCell.layer.rasterizationScale = [UIScreen mainScreen].scale;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
        
        NSString* imagePath  = [self imagePathFromDBWithIndex:indexPath.row];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            PostCollectionViewCell *updatedPostCell = (PostCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            updatedPostCell.postImage.alpha = 0.0;
            
            if (updatedPostCell) {
                [self imageFromDocumentsDirectory:imagePath completionHandler:^(UIImage *image) {                    
                    [UIView animateWithDuration:0.3f animations:^{
                        updatedPostCell.postImage.image = image;
                        [updatedPostCell.postImage setAlpha:1.0];
                    }];
                }];
                
            }
        });
    });
    
    return postCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    __block LSLocalPost* loadedPost;
    [self.localManager postWithIndexInDB:indexPath.row
                       completionHandler:^(id<LSLocalPostProtocol> post, NSError *error) {
                           
        if (!error) {
            loadedPost = post;
        }
    }];
    
    PreviewPostViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewPostViewController"];
    controller.localPost = loadedPost;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger cellWigth = ([[UIScreen mainScreen] bounds]).size.width / 3 - 8;
    CGSize cellSize     = CGSizeMake(cellWigth, cellWigth);
    
    return cellSize;
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
