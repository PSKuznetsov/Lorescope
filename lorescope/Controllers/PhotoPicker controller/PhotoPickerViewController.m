//
//  PhotoPickerViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 03/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "PhotoPickerViewController.h"
#import "PhotoPickerCollectionViewCell.h"

@interface PhotoPickerViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation PhotoPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return 16;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    PhotoPickerCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"imageCellID"
                                                                           forIndexPath:indexPath];
    
    cell.imageCell.image = [UIImage imageNamed:@"1.png"];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

#pragma mark - UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    CGSize cellSize = CGSizeMake(200.f, 200.f);
    
    return cellSize;
}

@end
