//
//  LoginViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField* loginEmailField;
@property (nonatomic, weak) IBOutlet UITextField* passwordField;

@property (nonatomic, weak) IBOutlet UILabel* loginEmailLabel;
@property (nonatomic, weak) IBOutlet UILabel* passwordLabel;

- (IBAction)loginButton:(id)sender;
- (IBAction)newAccountButton:(id)sender;

@end
