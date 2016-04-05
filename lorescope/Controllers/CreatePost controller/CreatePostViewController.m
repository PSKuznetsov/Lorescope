//
//  CreatePostViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 05/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//
#import <Realm/Realm.h>
#import "Post.h"
#import "CreatePostViewController.h"
#import "NewPostViewController.h"

@interface CreatePostViewController ()

@end

@implementation CreatePostViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    self.postImageView.layer.masksToBounds = YES;
    self.postImageView.layer.cornerRadius  = 25.f;
    self.postImageView.image = self.postImage;
}

#pragma mark - Actions

- (IBAction)doneButtonAction:(id)sender {
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    
    Post* newPost = [[Post alloc]init];
    newPost.comment   = self.postTextView.text;
    newPost.photoPath = @"";
    newPost.postID    = 2;
    newPost.publicationDate = [NSDate date];
    
    [realm addObject:newPost];
    
    [realm commitWriteTransaction];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
