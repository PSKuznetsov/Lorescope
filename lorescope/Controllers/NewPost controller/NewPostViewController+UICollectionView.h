//
//  NewPostViewController+UICollectionView.h
//  lorescope
//
//  Created by Paul Kuznetsov on 05/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "NewPostViewController.h"
#import "PhotoPickerCollectionViewCell.h"

@import Photos;

@interface NewPostViewController (UICollectionView) <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>
@end
