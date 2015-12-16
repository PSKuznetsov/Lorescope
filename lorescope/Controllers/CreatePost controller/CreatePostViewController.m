//
//  CreatePostViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 05/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "CreatePostViewController.h"
#import "NewPostViewController.h"

@interface CreatePostViewController ()

@end

@implementation CreatePostViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.postImageView.image             = self.postImage;

    self.backgroundImageView.image       = self.postImage;
    self.backgroundImageView.contentMode = UIViewContentModeScaleAspectFill;
    
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.view.bounds
                                                   byRoundingCorners:(UIRectCornerTopLeft | UIRectCornerTopRight)
                                                         cornerRadii:CGSizeMake(7.0, 7.0)];
    
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    
    maskLayer.frame = self.postImageView.bounds;
    maskLayer.path  = maskPath.CGPath;
    
    self.postImageView.layer.mask = maskLayer;
}

#pragma mark - Actions

- (IBAction)doneButtonAction:(id)sender {
    
    
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
