//
//  PhotoPickerViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 03/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PhotoPickerViewControllerDelegate;

@interface PhotoPickerViewController : UIViewController

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;

@property (nonatomic, weak) id <PhotoPickerViewControllerDelegate> delegate;

@end

@protocol PhotoPickerViewControllerDelegate <NSObject>

@required

- (void)userDidSelectImage:(UIImage *)image;
- (void)userDidDeselectImage;

@end
