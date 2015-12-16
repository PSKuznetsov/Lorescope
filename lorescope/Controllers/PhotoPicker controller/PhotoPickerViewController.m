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
@property (nonatomic, strong) NSIndexPath *selectedItemIndexPath;

@end

@implementation PhotoPickerViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.collectionView.allowsSelection = YES;
    [self.collectionView reloadData];
    
    //TODO: load all images to collection view after user permission request
}
- (void)loadView {
    [super loadView];
    
    [self.delegate userDidDeselectImage];
    //Fetching all user's photos
    //TODO: fetching only offline available photos
    self.fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
}

#pragma mark - Data

- (void)didSelectImageAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.fetchResult) {
        
        __weak typeof(self) weakSelf = self;
        
        PHAsset* asset = (PHAsset *)self.fetchResult[indexPath.row];
        //TODO: dynamic change content sizeß
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
    
    PHAsset* asset    = (PHAsset *)self.fetchResult[indexPath.row];
    CGSize tergetSize = CGSizeMake(74, 74);
    
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:tergetSize
                                              contentMode:PHImageContentModeAspectFit
                                                  options:nil
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                
                                                cell.imageCell.image = result;
                                                
                                            }];
    
    if (cell.selected) {
        
        cell.imageCell.layer.borderColor = [[UIColor blackColor] CGColor];
        cell.imageCell.layer.borderWidth = 2.0;
    }
    else {
        
        cell.imageCell.layer.borderColor = nil;
        cell.imageCell.layer.borderWidth = 0.0;
    }
    
    return cell;
}



#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPickerCollectionViewCell* cell = (PhotoPickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    
    cell.imageCell.layer.borderColor = [[UIColor blackColor] CGColor];
    cell.imageCell.layer.borderWidth = 2.0;
    
    [cell setSelected:YES];
    [self.collectionView selectItemAtIndexPath:indexPath animated:NO scrollPosition:UICollectionViewScrollPositionNone];
    
    [self didSelectImageAtIndexPath:indexPath];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPickerCollectionViewCell* cell = (PhotoPickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    //
    cell.imageCell.layer.borderColor = nil;
    cell.imageCell.layer.borderWidth = 0.0;
    
    [self.delegate userDidDeselectImage];
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize = CGSizeMake(74, 74);
    
    return cellSize;
}


@end
