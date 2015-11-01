//
//  LSBlurManager.m
//  lorescope
//
//  Created by Paul Kuznetsov on 22/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "LSAnimationManager.h"

@implementation LSAnimationManager {
    
    NSMutableArray* images;
}

#pragma mark - Root

+ (instancetype)sharedManager {
    
    static LSAnimationManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        manager = [[LSAnimationManager alloc] init];
        
    });
    
    return manager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self) {
        
        images = [NSMutableArray array];
        
        for (int index = 0; index < 3; ++index) {
            
            UIImage* image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.png", index]];
            
            [images addObject:image];
        }
    }
    return self;
}

#pragma mark - Animation

- (void)startAnimationForView:(JBKenBurnsView *)view {
    
    if (images) {
        [view animateWithImages:images
             transitionDuration:35.f
                   initialDelay:0.f
                           loop:YES
                    isLandscape:YES];
    }
    
}

@end
