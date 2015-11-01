//
//  SettingsViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 30/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITableView* tableView;

- (IBAction)backButton:(id)sender;

@end
