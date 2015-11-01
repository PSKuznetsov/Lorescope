//
//  LSSecureStore.h
//  lorescope
//
//  Created by Paul Kuznetsov on 29/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSSessionManager.h"

@interface LSSecureStore : NSObject

+ (instancetype)sharedStore;

#pragma mark - Security

- (void)saveUserDataToKeychain:(UserAuthResponseModel *)data;
- (NSDictionary *)userDataFromKeychain;

@end
