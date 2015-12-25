//
//  LSSessionManager.h
//  lorescope
//
//  Created by Paul Kuznetsov on 29/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
@class Parse;

@interface LSSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

@end
