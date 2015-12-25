//
//  NewPostViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 02/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "NewPostViewController.h"
#import "PhotoPickerViewController.h"
#import "CreatePostViewController.h"
#import "LSUILabel.h"

@interface NewPostViewController () <PhotoPickerViewControllerDelegate>

@property (nonatomic, strong) UIViewController* currentViewController;
@property (nonatomic, strong) UIImage* selectedImage;

@end

@implementation NewPostViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    //Setting up first child view controller
    UIViewController *vc = [self viewControllerForSegmentedControlIndex:self.pickerModControl.selectedSegmentIndex];
    
    [self addChildViewController:vc];
    
    vc.view.frame = self.containerView.bounds;
    
    [self.containerView addSubview:vc.view];
    
    self.currentViewController = vc;
    self.doneButton.enabled = NO;
}

#pragma mark - User Interaction Methods

//This method return proper VC for segment index
- (UIViewController *)viewControllerForSegmentedControlIndex:(NSInteger)index {
    
    UIViewController* vc;
    
    switch (index) {
        case 0: vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoPickerViewController"];
            
            ((PhotoPickerViewController *)vc).delegate = self;
            
            [self.titleInfoLabel setText:@"Choose photo"];
            self.doneButton.hidden = NO;
            break;
        
        case 1: vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TakePhotoViewController"];
            
            [self.titleInfoLabel setText:@"Take photo"];
            self.doneButton.hidden = YES;
            break;
    }
    
    return vc;
}

#pragma mark - PhotoPickerViewControllerDelegate

- (void)userDidSelectImage:(UIImage *)image {
    
    self.doneButton.enabled = YES;
    self.selectedImage      = image;
}

- (void)userDidDeselectImage {
    
    self.doneButton.enabled = NO;
}


#pragma mark - Actions

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)doneButton:(id)sender {
    
    CreatePostViewController* createPost = [self.storyboard instantiateViewControllerWithIdentifier:@"CreatePostViewController"];
    createPost.postImage = self.selectedImage;
    
    [self.navigationController showViewController:createPost sender:self];
}

//This method load new child VC with the UISegmentedControl actions
- (IBAction)segmentedControlIndexChangedAction:(UISegmentedControl *)sender {
    
    UIViewController* vc = [self viewControllerForSegmentedControlIndex:sender.selectedSegmentIndex];
    [self addChildViewController:vc];
    
    __weak typeof(self) weakSelf = self;
    
    [self transitionFromViewController:self.currentViewController
                      toViewController:vc
                              duration:0.3f
                               options:UIViewAnimationOptionTransitionCrossDissolve
                            animations:^{
        
                                [weakSelf.currentViewController.view removeFromSuperview];
                                vc.view.frame = weakSelf.containerView.bounds;
                                [weakSelf.containerView addSubview:vc.view];
                                
                            }
                            completion:^(BOOL finished) {
        
                                [vc didMoveToParentViewController:weakSelf];
                                [weakSelf.currentViewController removeFromParentViewController];
                                weakSelf.currentViewController = vc;
                            }];
    //TODO: set title here
    
}



@end






















