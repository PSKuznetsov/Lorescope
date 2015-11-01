//
//  SignUpViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBKenBurnsView;

@interface SignUpViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField* usernameField;
@property (nonatomic, weak) IBOutlet UITextField* emailField;
@property (nonatomic, weak) IBOutlet UITextField* passwordField;

@property (nonatomic, weak) IBOutlet JBKenBurnsView* backgroundView;

- (IBAction)signupButton:(id)sender;
- (IBAction)closeControllerButton:(id)sender;

@end
