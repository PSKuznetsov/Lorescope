//
//  PreviewPostViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 15/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PreviewPostViewController : UIViewController

@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, weak) IBOutlet UITextView* textView;

@property (nonatomic, strong) UIImage* image;
@property (nonatomic, copy) NSString* comment;

- (IBAction)backButtonDidPressed:(id)sender;

@end
