//
//  LSServerManager.m
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "LSServerManager.h"

@implementation LSServerManager

//Server Manager Singletone
+ (instancetype)sharedManager {
    
    static LSServerManager* manager = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        manager = [[LSServerManager alloc] init];
    });
    
    return manager;
}

@end
