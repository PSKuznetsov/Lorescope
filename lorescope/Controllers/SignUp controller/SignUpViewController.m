//
//  SignUpViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "SignUpViewController.h"
#import "Constants.h"

@interface SignUpViewController () <UITextFieldDelegate>

@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.emailField.delegate    = self;
    self.passwordField.delegate = self;
    self.usernameField.delegate = self;
}


#pragma mark - Actions
    ///Action method which handle "Sign Up" button. Maybe depricated in feature version.
- (IBAction)signupButton:(id)sender {
    
    if (self.usernameField.text > 0 && self.emailField.text > 0 && self.passwordField.text > 0) {
        
            //TODO:Auth goes here...
        
    }
    
}
    ///Action method which handle "Close" button
- (IBAction)closeControllerButton:(id)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

    // became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.usernameField]) {
        
        self.usernameLabel.hidden = YES;
        
    } else if ([textField isEqual:self.passwordField]){
        
        self.passwordLabel.hidden = YES;
        
    } else {
        
        self.emailLabel.hidden = YES;
    }
    
}

    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.usernameField]) {
        
        self.usernameLabel.hidden = NO;
        
    } else if ([textField isEqual:self.passwordField]){
        
        self.passwordLabel.hidden = NO;
        
    } else {
        
        self.emailLabel.hidden = NO;
    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHABETIC_CHARACTER] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}

@end
