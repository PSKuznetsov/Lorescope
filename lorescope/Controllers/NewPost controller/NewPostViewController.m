//
//  NewPostViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 02/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "NewPostViewController.h"

@interface NewPostViewController ()

@end

@implementation NewPostViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

#pragma mark - Actions

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)doneButton:(id)sender {
    
}

@end
