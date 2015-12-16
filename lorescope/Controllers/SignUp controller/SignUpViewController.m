//
//  SignUpViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "SignUpViewController.h"
#import "LSAnimationManager.h"
#import "LSSecureStore.h"
#import "LSSessionManager.h"

@interface SignUpViewController () <UITextFieldDelegate>

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emailField.delegate    = self;
    self.passwordField.delegate = self;
    self.usernameField.delegate = self;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[LSAnimationManager sharedManager] startAnimationForView:self.backgroundView];
}


#pragma mark - Actions

- (IBAction)signupButton:(id)sender {
    
    if (self.usernameField.text > 0 && self.emailField.text > 0 && self.passwordField.text > 0) {
        
    }
    
}

- (IBAction)closeControllerButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
        [self.backgroundView stopAnimation];
    }];

}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.usernameField]) {
        
        [self.emailField becomeFirstResponder];
    }
    else if ([textField isEqual:self.emailField]) {
        
        [self.passwordField becomeFirstResponder];
    }
    else {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@" ._@0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}

@end
