//
//  MainViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "LSUser.h"

@interface MainViewController : UIViewController

@property (nonatomic, strong, readonly) LSUser* user;
@property (nonatomic, strong) id <LSDataManipulatorProtocol> dataManipulator;
@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;

- (IBAction)settingsButton:(id)sender;
- (IBAction)newPostButton:(id)sender;

@end
