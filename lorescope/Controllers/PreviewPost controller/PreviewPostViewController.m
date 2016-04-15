//
//  PreviewPostViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 15/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "PreviewPostViewController.h"

@implementation PreviewPostViewController

- (void)viewWillAppear:(BOOL)animated {
    
    self.imageView.image = self.image;
    self.textView.text = self.comment;
}

- (IBAction)backButtonDidPressed:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
