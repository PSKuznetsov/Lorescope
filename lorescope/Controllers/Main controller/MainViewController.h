//
//  MainViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Realm/Realm.h>

#import "LSLocalPost.h"
#import "PostCollectionViewCell.h"
#import "LSControllerManipulatorDelegate.h"

@protocol LSLocalPostManagerProtocol;
@protocol LSDataSynchronizerProtocol;
@protocol LSRemotePostManagerProtocol;
@protocol LSImageManagerProtocol;

@interface MainViewController : UIViewController <LSControllerManipulatorDelegate>

@property (nonatomic, weak) IBOutlet UICollectionView* collectionView;

@property (nonatomic, strong) LSLocalPost* loadedPost;
@property (nonatomic, strong) NSMutableDictionary* cache;
@property (nonatomic, strong) PostCollectionViewCell* selectedCell;
@property (nonatomic, strong) UIImage* selectedImage;

@property (nonatomic, strong) id <LSLocalPostManagerProtocol> localManager;
@property (nonatomic, strong) id <LSDataSynchronizerProtocol> synchronizer;
@property (nonatomic, strong) id <LSRemotePostManagerProtocol> remoteManager;
@property (nonatomic, strong) id <LSImageManagerProtocol> imageManager;

- (IBAction)settingsButton:(id)sender;
- (IBAction)newPostButton:(id)sender;

@end
