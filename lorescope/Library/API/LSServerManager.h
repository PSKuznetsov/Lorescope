//
//  LSServerManager.h
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LSServerManager : NSObject

+ (instancetype)sharedManager;

- (void)userSignUpRequestWithUsername:(NSString *)username
                             password:(NSString *)password
                                email:(NSString *)email
                            onSuccess:(void (^)(NSArray* response)) success
                            onFailure:(void (^)(NSError * error)) failure;

- (void)userSignInRequestWithEmail:(NSString *)email
                             password:(NSString *)password
                            onSuccess:(void (^)(NSArray* response)) success
                            onFailure:(void (^)(NSError * error)) failure;

@end
