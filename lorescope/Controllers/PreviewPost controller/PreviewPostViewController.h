//
//  PreviewPostViewController.h
//  lorescope
//
//  Created by Paul Kuznetsov on 15/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LSPopupView.h"

@protocol LSDataSynchronizerProtocol;
@protocol LSLocalPostProtocol;

@interface PreviewPostViewController : UIViewController <LSPopupViewDelegate, UITextViewDelegate>

@property (nonatomic, weak) IBOutlet UIImageView* imageView;
@property (nonatomic, weak) IBOutlet UITextView* contentTextView;
@property (nonatomic, weak) IBOutlet UIScrollView* scrollView;
@property (nonatomic, weak) IBOutlet LSPopupView* popupView;
@property (nonatomic, weak) IBOutlet UIVisualEffectView* bluredView;

@property (nonatomic, strong) id <LSLocalPostProtocol> localPost;
@property (nonatomic, strong) UIImage* postImage;
@property (nonatomic, strong) id <LSDataSynchronizerProtocol> dataSynchronizer;

- (IBAction)editButtonDidPressed:(UIButton *)sender;
- (IBAction)deleteButtonDidPressed:(UIButton *)sender;

@end
