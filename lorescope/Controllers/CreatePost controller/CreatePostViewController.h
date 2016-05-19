//
//  CreatePostViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 05/11/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSDataManipulatorProtocol;
@protocol LSImageManagerProtocol;

@interface CreatePostViewController : UIViewController

@property (nonatomic, weak) IBOutlet UITextView  *   postTextView;
@property (nonatomic, weak) IBOutlet UIImageView *   postImageView;
@property (nonatomic, weak) IBOutlet UIScrollView*   scrollView;

@property (nonatomic, strong) UIImage* postImage;
@property (nonatomic, strong) id <LSDataManipulatorProtocol> dataSynchronizer;
@property (nonatomic, strong) id <LSImageManagerProtocol> imageManager;

- (IBAction)doneButtonAction:(id)sender;

@end
