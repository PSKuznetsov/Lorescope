//
//  LSSessionManager.m
//  lorescope
//
//  Created by Paul Kuznetsov on 29/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "LSSessionManager.h"

@implementation LSSessionManager

#pragma mark - Root

+ (instancetype)sharedManager {
    
    static LSSessionManager* manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[LSSessionManager alloc] init];
    });
    
    return manager;
}

- (instancetype)init {
    
    if (!self) return nil;
    

    return self;
}

#pragma mark - Authentication

@end
