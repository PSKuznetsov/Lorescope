//
//  NewPostViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 02/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
@import Photos;

@class LSUILabel;

@interface NewPostViewController : UIViewController

@property (nonatomic, weak) IBOutlet LSUILabel* titleInfoLabel;
@property (nonatomic, weak) IBOutlet UIButton* doneButton;
@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;

@property (nonatomic, strong) NSIndexPath* selectedItemIndexPath;
@property (nonatomic, strong) PHFetchResult* fetchResult;
@property (nonatomic, strong) UIImage* selectedImage;

- (IBAction)doneButton:(id)sender;

@end


