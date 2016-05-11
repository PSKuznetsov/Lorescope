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
#import "LSLocalPost.h"
#import "LSLocalPostManagerProtocol.h"
#import "PostCollectionViewCell.h"
#import "LSControllerManipulatorDelegate.h"

@interface MainViewController : UIViewController <LSControllerManipulatorDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;

@property (nonatomic, strong, readonly) LSUser* user;
@property (nonatomic, strong) LSLocalPost* loadedPost;
@property (nonatomic, strong) NSMutableDictionary* cache;
@property (nonatomic, strong) PostCollectionViewCell* selectedCell;
@property (nonatomic, strong) UIImage* selectedImage;

@property (nonatomic, strong) id <LSLocalPostManagerProtocol> localManager;

- (IBAction)settingsButton:(id)sender;
- (IBAction)newPostButton:(id)sender;

@end
