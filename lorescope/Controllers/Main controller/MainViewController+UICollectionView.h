//
//  MainViewController+UICollectionView.h
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//
#import "MainViewController.h"
#import <ZOZolaZoomTransition.h>

@interface MainViewController (UICollectionView) <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,ZOZolaZoomTransitionDelegate, UINavigationControllerDelegate>
@end
