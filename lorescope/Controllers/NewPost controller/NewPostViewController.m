//
//  NewPostViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 02/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "NewPostViewController.h"
#import "CreatePostViewController.h"

@interface NewPostViewController ()

@property (nonatomic, strong) UIViewController* currentViewController;

@end

@implementation NewPostViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIViewController *vc = [self viewControllerForSegmentedControlIndex:self.pickerModControl.selectedSegmentIndex];
    
    [self addChildViewController:vc];
    vc.view.frame = self.containerView.bounds;
    [self.containerView addSubview:vc.view];
    
    self.currentViewController = vc;
}

//This method return proper VC for segment index
- (UIViewController *)viewControllerForSegmentedControlIndex:(NSInteger)index {
    
    UIViewController* vc;
    
    switch (index) {
        case 0: vc = [self.storyboard instantiateViewControllerWithIdentifier:@"PhotoPickerViewController"];
            self.doneButton.hidden = NO;
            break;
        case 1: vc = [self.storyboard instantiateViewControllerWithIdentifier:@"TakePhotoViewController"];
            self.doneButton.hidden = YES;
            break;
    }
    
    return vc;
}

#pragma mark - Actions

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)doneButton:(id)sender {
    
    UIImage* postImage = [self.delegate viewController:self didTappedDoneButton:self.doneButton];
    
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

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
}

@end






















