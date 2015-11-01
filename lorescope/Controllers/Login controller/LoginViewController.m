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
#import "LSAnimationManager.h"
#import "LSSecureStore.h"
#import "LSSessionManager.h"


@interface LoginViewController() <UITextFieldDelegate>

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.loginEmailField.delegate = self;
    self.passwordField.delegate   = self;
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [[LSAnimationManager sharedManager] startAnimationForView:self.backgroundView];
}

#pragma mark - Actions

- (IBAction)loginButton:(id)sender {
    
    if (self.loginEmailField.text != nil && self.passwordField.text != nil) {
        
        //AES encrypt password for request
        NSString* encryptedPassword = [AESCrypt encrypt:self.passwordField.text password:API_AUTH_PASSWORD];
        
        UserSignInRequestModel* requestModel = [UserSignInRequestModel new];
        
        requestModel.email    = self.loginEmailField.text;
        requestModel.password = encryptedPassword;
        
        
        [[LSSessionManager sharedManager] postUserSignInWithRequestModel:requestModel success:^(UserAuthResponseModel *responseModel) {
            
            //Save user's sensitive data to keychain
            [[LSSecureStore sharedStore] saveUserDataToKeychain:responseModel];
            //
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"UserDidAuth"];
            //
            UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            
            MainViewController* mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
            UINavigationController* navController  = [[UINavigationController alloc] initWithRootViewController:mainViewController];
            
            [self presentViewController:navController animated:NO completion:nil];
            
        } failure:^(NSError *error) {
            NSLog(@"%@", [error localizedDescription]);
        }];
    }
    
}

- (IBAction)newAccountButton:(id)sender {
    
    SignUpViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
   
    [self presentViewController:vc animated:YES completion:^{
       
        [self.backgroundView stopAnimation];
    }];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSCharacterSet *cs = [[NSCharacterSet characterSetWithCharactersInString:@"._@0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"] invertedSet];
    
    NSString *filtered = [[string componentsSeparatedByCharactersInSet:cs] componentsJoinedByString:@""];
    
    return [string isEqualToString:filtered];
}

@end
