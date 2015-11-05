//
//  CreatePostViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 05/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatePostViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImage *       backgroundImage;
@property (nonatomic, weak) IBOutlet UIView  *       contentView;
@property (nonatomic, weak) IBOutlet UILabel *       titleTextLabel;
@property (nonatomic, weak) IBOutlet UITextField *   textfield;

@property (nonatomic, strong) UIImage* postImage;

@end
