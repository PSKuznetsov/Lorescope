//
//  PreviewPostViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 15/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "PreviewPostViewController.h"

#import "SVProgressHUD.h"

#import "JTSImageViewController.h"
#import "JTSImageInfo.h"

#import "LSLocalPostProtocol.h"
#import "LSLocalPost.h"

#import "LSDataManipulatorProtocol.h"
#import "LSDataManipulator.h"

#import "LSControllerManipulatorDelegate.h"

typedef NS_ENUM(NSUInteger, LSUIButtonState) {
    LSUIButtonStateEdit,
    LSUIButtonStateSave,
    LSUIButtonStateDefault,
};

@interface PreviewPostViewController ()

@property (nonatomic, assign) LSUIButtonState buttonState;
@property (nonatomic, assign) BOOL contentIsChanged;
@property (nonatomic, strong) id <LSControllerManipulatorDelegate> manipulatorDelegate;

@end

@implementation PreviewPostViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.97 alpha:1.0];
    self.imageView.image = self.postImage;
    self.contentTextView.text = self.localPost.content;
    
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewDidTapped)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    self.imageView.userInteractionEnabled = YES;
    [self.imageView addGestureRecognizer:tapGestureRecognizer];
    
    self.buttonState = LSUIButtonStateEdit;
    
    [self registerForKeyboardNotifications];
    
    self.popupView.delegate = self;
    self.dataSynchronizer = [[LSDataManipulator alloc]init];
    self.manipulatorDelegate = self.navigationController.viewControllers.firstObject;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.bluredView.hidden = YES;
    self.popupView.hidden  = YES;
    self.contentIsChanged  = NO;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

#pragma mark - Actions

- (void)imageViewDidTapped {
        // Create image info
    JTSImageInfo *imageInfo = [[JTSImageInfo alloc] init];
    
    imageInfo.image = self.imageView.image;
    imageInfo.referenceRect = self.imageView.frame;
    imageInfo.referenceView = self.imageView.superview;
    imageInfo.referenceContentMode = self.imageView.contentMode;
    imageInfo.referenceCornerRadius = self.imageView.layer.cornerRadius;
    
        // Setup view controller
    JTSImageViewController *imageViewer = [[JTSImageViewController alloc]
                                           initWithImageInfo:imageInfo
                                           mode:JTSImageViewControllerMode_Image
                                           backgroundStyle:JTSImageViewControllerBackgroundOption_Scaled];
    
        // Present the view controller.
    [imageViewer showFromViewController:self transition:JTSImageViewControllerTransition_FromOriginalPosition];
}

- (IBAction)editButtonDidPressed:(id)sender {
    
    if (self.buttonState == LSUIButtonStateEdit) {
        
        self.buttonState = LSUIButtonStateSave;
            //self.deleteButton.hidden = NO;
        
        [sender setBackgroundImage:[UIImage imageNamed:@"doneButton"]
                          forState:UIControlStateNormal];
        
        self.contentTextView.editable = YES;
    }
    else if (self.buttonState == LSUIButtonStateSave) {
        
        self.buttonState = LSUIButtonStateEdit;
            //self.deleteButton.hidden = YES;
        
        [sender setBackgroundImage:[UIImage imageNamed:@"newPost"]
                          forState:UIControlStateNormal];
        
        self.contentTextView.editable = NO;
        
        if (self.contentIsChanged) {
            
            [SVProgressHUD show];
            
            [self.dataSynchronizer shouldUpdateLocalPost:self.localPost
                                             withContent:self.contentTextView.text
                                       completionHandler:^(BOOL success) {
                
                if (success) {
                    
                    [SVProgressHUD dismiss];
                    [SVProgressHUD showSuccessWithStatus:@"Save successfully!"];
                    [SVProgressHUD dismissWithDelay:5.f];
                }
                else {
                    
                    [SVProgressHUD showErrorWithStatus:@"Save failure!"];
                    [SVProgressHUD dismissWithDelay:5.f];
                }
                
            }];
        }
    }    
}

- (IBAction)deleteButtonDidPressed:(id)sender {
    
    self.bluredView.hidden = NO;
    self.popupView.hidden  = NO;
    self.popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.popupView.transform = CGAffineTransformIdentity;
            }];
        }];
    }];
}

#pragma mark - LSPopupViewDelegate

- (void)popupViewDeleteButtonDidPressed:(LSPopupView *)view {
    
    [self popupViewCancelButtonDidPressed:self.popupView];
    
    __weak typeof(self) weakSelf = self;
    
    [SVProgressHUD show];
    
    NSLog(@"Will delete local post with id - %@", self.localPost.postID);
    
    [self.dataSynchronizer shouldDeleteLocalPost:self.localPost completionHandler:^(BOOL success) {
        
        typeof(self) strongSelf = weakSelf;
        
        if (success) {
            
            [SVProgressHUD dismiss];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [strongSelf.navigationController popViewControllerAnimated:YES];
                [strongSelf.manipulatorDelegate contorllerShouldPerformReloadData:nil];
            });
        }
        else {
            
            [SVProgressHUD dismiss];
            [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Failed to delete the item", nil)];
            [SVProgressHUD dismissWithDelay:5.f];
        }
    }];
}

- (void)popupViewCancelButtonDidPressed:(LSPopupView *)view {
    
    [UIView animateWithDuration:0.3/1.5 animations:^{
        self.popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3/2 animations:^{
            self.popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1, 1);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.3/2 animations:^{
                self.popupView.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
            } completion:^(BOOL finished) {
                self.bluredView.hidden = YES;
                self.popupView.hidden  = YES;
            }];
        }];
    }];
        
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    NSLog(@"TextView did changed!");
    self.contentIsChanged = YES;
}

#pragma mark - ScrollView behavior

    // Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
    
        // If active text field is hidden by keyboard, scroll it so it's visible
        // Your application might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= kbSize.height;
    
    if (!CGRectContainsPoint(aRect, self.contentTextView.frame.origin)) {
        
        CGPoint scrollPoint = CGPointMake(0.0, self.contentTextView.frame.origin.y - kbSize.height);
        [self.scrollView setContentOffset:scrollPoint animated:YES];
    }
}

    // Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

#pragma mark - Notifications

    // Call this method somewhere in your view controller setup code.
- (void)registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Utils

- (UIImage *)imageFromDocumentsDirectory:(NSString *)imagePath {
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:imagePath];
    
    NSData *pngData      = [NSData dataWithContentsOfFile:path];
    UIImage *loadedImage = [UIImage imageWithData:pngData];
    
    return loadedImage;
}

@end
