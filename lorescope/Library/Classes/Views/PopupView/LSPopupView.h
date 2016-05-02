//
//  LSPopupView.h
//  lorescope
//
//  Created by Paul Kuznetsov on 30/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LSPopupViewDelegate;

@interface LSPopupView : UIView

@property (nonatomic, weak) IBOutlet UILabel* infoLabel;
@property (nonatomic, strong) id <LSPopupViewDelegate> delegate;

- (IBAction)deleteButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;

@end

@protocol LSPopupViewDelegate <NSObject>

- (void)popupViewDeleteButtonDidPressed:(LSPopupView *)view;
- (void)popupViewCancelButtonDidPressed:(LSPopupView *)view;

@end