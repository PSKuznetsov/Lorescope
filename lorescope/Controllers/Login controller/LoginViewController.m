//
//  LoginViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"
#import "MainViewController.h"
#import "Constants.h"

@interface LoginViewController() <UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginEmailField.delegate = self;
    self.passwordField.delegate   = self;
    
    
}

#pragma mark - Actions

- (IBAction)loginButton:(id)sender {
    
    if (self.loginEmailField.text != nil && self.passwordField.text != nil) {
        
            //TODO: Auth goes here...
            //Below is legacy code with route logic
        
//        [[LSSessionManager sharedManager] postUserSignInWithRequestModel:requestModel success:^(UserAuthResponseModel *responseModel) {
//            
//            //Save user's sensitive data to keychain
//            [[LSSecureStore sharedStore] saveUserDataToKeychain:responseModel];
//            //
//            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserDidAuth"];
//            //
//            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//            
//            MainViewController* mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
//            UINavigationController* navController  = [[UINavigationController alloc] initWithRootViewController:mainViewController];
//            
//            [self presentViewController:navController animated:NO completion:nil];
//            
//        } failure:^(NSError *error) {
//            NSLog(@"%@", [error localizedDescription]);
//        }];
    }
    
}

- (IBAction)newAccountButton:(id)sender {
    
    SignUpViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    
    [self presentViewController:vc animated:YES completion:nil];
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if ([textField isEqual:self.loginEmailField]) {
        
        [self.passwordField becomeFirstResponder];
    }
    else {
        
        [textField resignFirstResponder];
    }
    
    return YES;
}

    // became first responder
- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.loginEmailField]) {
        
        self.loginEmailLabel.hidden = YES;
        
    } else {
        
        self.passwordLabel.hidden = YES;
    }
    
}

    // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    if ([textField isEqual:self.loginEmailField]) {
        
        self.loginEmailLabel.hidden = NO;
        
    } else {
        
        self.passwordLabel.hidden = NO;
    }
    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:ALPHABETIC_CHARACTER] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}

@end
