//
//  NewPostViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 02/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LSUILabel;

@interface NewPostViewController : UIViewController

@property (nonatomic, weak) IBOutlet LSUILabel* titleInfoLabel;
@property (nonatomic, weak) IBOutlet UISegmentedControl* pickerModControl;
@property (nonatomic, weak) IBOutlet UIView* containerView;

- (IBAction)backButton:(id)sender;
- (IBAction)doneButton:(id)sender;

@end
