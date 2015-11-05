//
//  NewPostViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 02/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSUILabel;

@protocol NewPostViewControllerDelegate;

@interface NewPostViewController : UIViewController

@property (nonatomic, weak) IBOutlet LSUILabel* titleInfoLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl* pickerModControl;
@property (nonatomic, weak) IBOutlet UIView* containerView;
@property (nonatomic, weak) IBOutlet UIButton* doneButton;

@property (nonatomic, weak) id <NewPostViewControllerDelegate> delegate;

- (IBAction)backButton:(id)sender;
- (IBAction)doneButton:(id)sender;
- (IBAction)segmentedControlIndexChangedAction:(UISegmentedControl *)sender;

@end


@protocol NewPostViewControllerDelegate <NSObject>

@required

- (UIImage *)viewController:(UIViewController *)controller didTappedDoneButton:(UIButton *)button;

@end