//
//  NewPostViewController+UICollectionView.m
//  lorescope
//
//  Created by Paul Kuznetsov on 05/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "NewPostViewController+UICollectionView.h"

@implementation NewPostViewController (UICollectionView)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.doneButton.enabled = NO;
    
    self.collectionView.delegate   = self;
    self.collectionView.dataSource = self;
    
    [self.collectionView reloadData];
}

- (void)loadView {
    [super loadView];
    
    self.fetchResult = [PHAsset fetchAssetsWithMediaType:PHAssetMediaTypeImage options:nil];
    NSLog(@"Fetched %lu items", (unsigned long)[self.fetchResult count]);
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return [self.fetchResult count];
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPickerCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCellID"
                                                                                    forIndexPath:indexPath];
    
    cell.imageCell.image = [UIImage imageNamed:@"cell_placeholder"];
    
    PHAsset* asset = (PHAsset *)self.fetchResult[indexPath.row];
    
    PHImageRequestOptions* options = [[PHImageRequestOptions alloc] init];
    options.version      = PHImageRequestOptionsVersionCurrent;
    options.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    options.resizeMode   = PHImageRequestOptionsResizeModeExact;
    options.networkAccessAllowed = YES;
//    options.progressHandler = ^(double progress, NSError *error, BOOL *stop, NSDictionary *info) {
//        NSLog(@"%f", progress); //follow progress + update progress bar
//    };
    
    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:CGSizeMake(800, 800)
                                              contentMode:PHImageContentModeAspectFit
                                                  options:options
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
                                                
                                                PhotoPickerCollectionViewCell* updatedCell = (PhotoPickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
                                                    if (updatedCell) {
                                                    updatedCell.imageCell.image = result;
                                                    }
                                                
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
    self.selectedImage = cell.imageCell.image;
    self.doneButton.enabled = YES;
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPickerCollectionViewCell* cell = (PhotoPickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        //
    cell.imageCell.layer.borderColor = nil;
    cell.imageCell.layer.borderWidth = 0.0;
    
    self.doneButton.enabled = NO;
}



#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger cellWigth = ([[UIScreen mainScreen] bounds]).size.width / 3 - 8;
    CGSize cellSize     = CGSizeMake(cellWigth, cellWigth);
    
    return cellSize;
}

@end
