//
//  LSUILabel.m
//  lorescope
//
//  Created by Paul Kuznetsov on 20/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "LSUILabel.h"

@implementation LSUILabel

- (void)setFont:(UIFont *)font {

    font = [UIFont fontWithName:@"Tsukushi B Round Gothic" size:font.pointSize];
    [super setFont:font];
}

@end
