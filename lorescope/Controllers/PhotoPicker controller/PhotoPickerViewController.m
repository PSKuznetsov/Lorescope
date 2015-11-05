//
//  PhotoPickerViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 03/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "PhotoPickerCollectionViewCell.h"

@import Photos;

@interface PhotoPickerViewController() <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PHFetchResult* fetchResult;

@end

@implementation PhotoPickerViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView reloadData];
    //TODO: load all images to collection view after user permission request
}
- (void)loadView {
    [super loadView];
    
    //Fetching all user's photos
    self.fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
}

#pragma mark - Data

- (void)didSelectImageAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.fetchResult) {
        
        __weak typeof(self) weakSelf = self;
        
        PHAsset* asset = (PHAsset *)self.fetchResult[indexPath.row];
        CGSize targetSize = CGSizeMake(800.f, 800.f);
        
        [[PHImageManager defaultManager] requestImageForAsset:asset
                                                   targetSize:targetSize
                                                  contentMode:PHImageContentModeAspectFill
                                                      options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                          
                                                         [weakSelf.delegate userDidSelectImage:result];
                                                          
                                                      }];
        
    }
    
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.fetchResult count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPickerCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCellID"
                                                                                    forIndexPath:indexPath];
    
    //cell.imageCell.image = [UIImage imageNamed:@"1.png"];
    
    PHAsset* asset = (PHAsset *)self.fetchResult[indexPath.row];
    CGSize tergetSize = CGSizeMake(74, 74);
    
    [[PHImageManager defaultManager] requestImageForAsset:asset  targetSize:tergetSize
                                              contentMode:PHImageContentModeDefault
                                                  options:nil
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                
                                                cell.imageCell.image = result;
                                                
                                            }];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Cell did select at path: %ld", (long)indexPath.row);
    
    [self didSelectImageAtIndexPath:indexPath];
    
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.delegate userDidDiselectImage];
}


#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize = CGSizeMake(74, 74);
    
    
    return cellSize;
}


@end
