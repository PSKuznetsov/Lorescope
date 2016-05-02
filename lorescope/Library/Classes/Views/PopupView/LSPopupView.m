//
//  LSPopupView.m
//  lorescope
//
//  Created by Paul Kuznetsov on 30/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "LSPopupView.h"

@interface LSPopupView ()

@property (nonatomic, strong) UIView* view;

@end

@implementation LSPopupView

#pragma mark - Initialization

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 5.f;
        [self xibSetup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 15.f;
        [self xibSetup];
    }
    return self;
}

- (void)xibSetup {
    
    self.view = [self loadViewFromNib];
    self.view.frame = self.bounds;
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self addSubview:self.view];
}

- (UIView *)loadViewFromNib {
    
    NSBundle* bundle = [NSBundle mainBundle];
    UINib* nib = [UINib nibWithNibName:@"LSPopupView" bundle:bundle];
    UIView* view = [[nib instantiateWithOwner:self options:nil] firstObject];
    
    return view;
}

#pragma mark - Actions

- (IBAction)deleteButtonAction:(id)sender {
    [self.delegate popupViewDeleteButtonDidPressed:self];
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.delegate popupViewCancelButtonDidPressed:self];
}

@end
