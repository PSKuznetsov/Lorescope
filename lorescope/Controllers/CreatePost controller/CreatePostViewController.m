    //
    //  CreatePostViewController.m
    //  lorescope
    //
    //  Created by Paul Kuznetsov on 05/11/15.
    //  Copyright © 2015 Paul Kuznetsov. All rights reserved.
    //
#import <Realm/Realm.h>
#import <SVProgressHUD.h>

#import "LSLocalPost.h"
#import "LSDataSynchronizer.h"
#import "CreatePostViewController.h"
#import "NewPostViewController.h"

@interface CreatePostViewController () <UITextViewDelegate>
@end

@implementation CreatePostViewController

#pragma mark - Root

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registerForKeyboardNotifications];
    
    self.postImageView.layer.masksToBounds = YES;
    self.postImageView.layer.cornerRadius  = 5.f;
    self.postImageView.image = self.postImage;
    
    self.dataSynchronizer = [[LSDataSynchronizer alloc]init];
    
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - Actions

- (IBAction)doneButtonAction:(id)sender {
    
    
    
    LSLocalPost* newPost = [[LSLocalPost alloc]init];
    newPost.content   = self.postTextView.text;
    newPost.photoPath = [self storeImageOnDisk:self.postImage];
    
    [SVProgressHUD show];
    
    [self.dataSynchronizer shouldSaveLocalPost:newPost completionHandler:^(BOOL success) {
        
        
            if (success) {
                
                [SVProgressHUD dismiss];
                
                dispatch_async(dispatch_get_main_queue(), ^(){
                    [self.navigationController popToRootViewControllerAnimated:YES];
                });
            }
            else {
                
                [SVProgressHUD showErrorWithStatus:NSLocalizedString(@"Failed to save Photo", nil)];
                [SVProgressHUD dismissWithDelay:25.f];
            }
    }];
    
}

- (IBAction)backButtonAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
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
    
    if (!CGRectContainsPoint(aRect, self.postTextView.frame.origin)) {
        
        CGPoint scrollPoint = CGPointMake(0.0, self.postTextView.frame.origin.y - kbSize.height);
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

#pragma mark - UITextViewDelegate

- (void)textViewDidBeginEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@"placeholder text here..."]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"placeholder text here...";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

#pragma mark - Utils

- (NSString *)storeImageOnDisk:(UIImage *)image {
    
    NSData* imageData = UIImagePNGRepresentation(image);
    NSArray *paths    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd\'T\'HH-mm-ss"];
    
    NSString* dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString* imageNameComponent  = [NSString stringWithFormat:@"cahed-%@.png", dateString];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent: imageNameComponent];
    
    [imageData writeToFile:imagePath atomically:YES];
    
    return imageNameComponent;
}

@end
