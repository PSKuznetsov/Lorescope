//
//  LoginViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "LoginViewController.h"
#import "LSServerManager.h"
#import "UIImage+ImageEffects.h"
#import <JBKenBurnsView.h>

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImage* image_one = [UIImage imageNamed:@"autumn-in-wild-nature.jpg"];
    
    image_one = [image_one applyBlurWithRadius:8.f
                                     tintColor:[UIColor colorWithRed:0
                                                               green:0
                                                                blue:0
                                                               alpha:0.6]
                         saturationDeltaFactor:1
                                     maskImage:nil];
    
    
    NSArray* imagesArray = [NSArray arrayWithObject:image_one];
    
    [self.backgroundView animateWithImages:imagesArray
                        transitionDuration:35.f
                              initialDelay:0.f
                                      loop:YES
                               isLandscape:YES];
    
}



#pragma mark - Actions

- (IBAction)loginButton:(id)sender {
    
    [[LSServerManager sharedManager] userSignInRequestWithEmail:self.loginEmailField.text
                                                       password:self.passwordField.text
                                                      onSuccess:^(NSArray *response) {
        
                                                      }
                                                      onFailure:^(NSError *error) {
        
                                                      }];
}

- (IBAction)newAccountButton:(id)sender {
    
    [self performSegueWithIdentifier:@"newAccountSegue" sender:self];
}

@end
