//
//  LoginViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 16/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class JBKenBurnsView;

@interface LoginViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextField* loginEmailField;
@property (nonatomic, weak) IBOutlet UITextField* passwordField;
@property (nonatomic, weak) IBOutlet JBKenBurnsView* backgroundView;

- (IBAction)loginButton:(id)sender;
- (IBAction)newAccountButton:(id)sender;

@end
