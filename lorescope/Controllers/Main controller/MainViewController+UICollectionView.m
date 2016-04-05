//
//  MainViewController+UICollectionView.m
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//
#import "Post.h"
#import "MainViewController+UICollectionView.h"
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
    
    postCell.postImage.image = [UIImage imageNamed:@"0.png"];
    
    return postCell;
}

@end
