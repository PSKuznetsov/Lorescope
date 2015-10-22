//
//  SignUpViewController.m
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "SignUpViewController.h"



@interface SignUpViewController ()
@property (nonatomic, strong) NSMutableArray* backgroundImages;
@end

@implementation SignUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    
    
    [self prepareBackgroundImagesWithCompletion:^{
        [self applyBlurEffectToImages:self.backgroundImages];
        [self startAnimationBackgroundWithImages:self.backgroundImages];
    }];
}

- (void)dealloc {
    NSLog(@"VC Dealloceted");
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (IBAction)signupButton:(id)sender {
    
//    [[LSServerManager sharedManager] userSignUpRequestWithUsername:self.usernameField.text
//                                                          password:self.passwordField.text
//                                                             email:self.emailField.text
//                                                         onSuccess:^(NSArray *response) {
//                                                             
//                                                         }
//                                                         onFailure:^(NSError *error) {
//                                                             
//                                                         }];
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
