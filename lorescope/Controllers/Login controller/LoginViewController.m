//
//  LoginViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "LoginViewController.h"
#import "SignUpViewController.h"

@interface LoginViewController ()

@property (nonatomic, strong) NSMutableArray* backgroundImages;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self prepareBackgroundImagesWithCompletion:^{
        [self applyBlurEffectToImages:self.backgroundImages];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [self startAnimationBackgroundWithImages:self.backgroundImages];
}

#pragma mark - Animations

- (void)prepareBackgroundImagesWithCompletion:(void(^)())completion {
    
    self.backgroundImages = [NSMutableArray array];
    
    for (int i = 1; i <= 4; i++) {
        
        UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        
        [self.backgroundImages addObject:image];
    }
    
    if (completion) {
        completion();
    }
    
}

- (void)startAnimationBackgroundWithImages:(NSArray *)images {
    
    [self.backgroundView animateWithImages:images
                        transitionDuration:35.f
                              initialDelay:0.f
                                      loop:YES
                               isLandscape:YES];
     
    
}

- (void)applyBlurEffectToImages:(NSMutableArray *)images {
    
    for (NSInteger i = 0; i < images.count; i++) {
        
        UIImage* curImage = images[i];
        
        curImage = [curImage applyBlurWithRadius:8.f
                                 tintColor:[UIColor blurDefaultColor]
                     saturationDeltaFactor:1
                                 maskImage:nil];
        images[i] = curImage;
    }
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
    
    SignUpViewController* vc = [self.storyboard instantiateViewControllerWithIdentifier:@"SignUpViewController"];
    [self presentViewController:vc animated:YES completion:nil];
    
}

@end
