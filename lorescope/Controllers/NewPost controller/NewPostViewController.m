//
//  NewPostViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 02/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "NewPostViewController.h"
#import "CreatePostViewController.h"
#import "LSUILabel.h"


@interface NewPostViewController ()

@end

@implementation NewPostViewController

#pragma mark - Actions

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)doneButton:(id)sender {
    
    CreatePostViewController* createPost = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePostViewController"];
    createPost.postImage = self.selectedImage;
    
    [self.navigationController showViewController:createPost sender:self];
}



@end






















