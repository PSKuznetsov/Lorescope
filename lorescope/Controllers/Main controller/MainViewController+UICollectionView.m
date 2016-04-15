//
//  MainViewController+UICollectionView.m
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//
#import "Post.h"
#import "MainViewController+UICollectionView.h"
#import "PreviewPostViewController.h"
#import "PostCollectionViewCell.h"

@implementation MainViewController (UICollectionView)

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"numberOfItemsInSection: %ld", (unsigned long)[self.results count]);
    return [self.results count];
}

    // The cell that is returned must be retrieved from a call to -dequeueReusableCellWithReuseIdentifier:forIndexPath:
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PostCollectionViewCell *postCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"PhotoCellID"
                                                                                 forIndexPath:indexPath];
    
    Post* loadedPost = [self.results objectAtIndex:indexPath.row];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:loadedPost.photoPath];
    
    NSData *pngData      = [NSData dataWithContentsOfFile:path];
    UIImage *loadedImage = [UIImage imageWithData:pngData];
    
    postCell.postImage.image = loadedImage;
    
    return postCell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    Post* loadedPost = [self.results objectAtIndex:indexPath.row];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:loadedPost.photoPath];
    
    NSData *pngData      = [NSData dataWithContentsOfFile:path];
    UIImage *loadedImage = [UIImage imageWithData:pngData];
    
    PreviewPostViewController* controller = [self.storyboard instantiateViewControllerWithIdentifier:@"PreviewPostViewController"];
    controller.image = loadedImage;
    controller.comment = loadedPost.comment;
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger cellWigth = ([[UIScreen mainScreen] bounds]).size.width / 3 - 8;
    CGSize cellSize     = CGSizeMake(cellWigth, cellWigth);
    
    return cellSize;
}

@end
