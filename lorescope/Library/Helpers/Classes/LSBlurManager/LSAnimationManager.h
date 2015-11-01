//
//  LSBlurManager.h
//  lorescope
//
//  Created by Paul Kuznetsov on 22/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSAnimationManager : NSObject

+ (instancetype)sharedManager;

- (void)startAnimationForView:(JBKenBurnsView *)view;

@end
