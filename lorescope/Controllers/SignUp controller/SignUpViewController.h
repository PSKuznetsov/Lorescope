//
//  SignUpViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField* usernameField;
@property (nonatomic, weak) IBOutlet UITextField* emailField;
@property (nonatomic, weak) IBOutlet UITextField* passwordField;

@property (nonatomic, weak) IBOutlet UILabel* usernameLabel;
@property (nonatomic, weak) IBOutlet UILabel* emailLabel;
@property (nonatomic, weak) IBOutlet UILabel* passwordLabel;


- (IBAction)signupButton:(id)sender;
- (IBAction)closeControllerButton:(id)sender;

@end
