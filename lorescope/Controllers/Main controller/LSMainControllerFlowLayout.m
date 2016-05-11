//
//  LSMainControllerFlowLayout.m
//  lorescope
//
//  Created by Paul Kuznetsov on 05/05/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "LSMainControllerFlowLayout.h"

@implementation LSMainControllerFlowLayout

- (instancetype)init {
    self = [super init];
    if (self)
    {
        self.minimumLineSpacing = 1.0;
        self.minimumInteritemSpacing = 1.0;
        self.scrollDirection = UICollectionViewScrollDirectionVertical;
    }
    return self;
}

- (CGSize)itemSize {
    
    NSInteger numberOfColumns = 3;
    
    CGFloat itemWidth = (CGRectGetWidth(self.collectionView.frame) - (numberOfColumns)) / numberOfColumns;
    return CGSizeMake(itemWidth, itemWidth);
}

@end
