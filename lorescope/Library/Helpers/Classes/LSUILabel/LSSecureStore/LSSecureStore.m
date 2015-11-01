//
//  LSSecureStore.m
//  lorescope
//
//  Created by Paul Kuznetsov on 29/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "LSSecureStore.h"

@implementation LSSecureStore

+ (instancetype)sharedStore {
    
    static LSSecureStore* store = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        store = [[LSSecureStore alloc] init];
    });
    
    return store;
}

#pragma mark - Security

- (void)saveUserDataToKeychain:(UserAuthResponseModel *)data {

    KeychainWrapper* keychain = [[KeychainWrapper alloc]init];
        
//    NSDictionary* valueData = @{ @"api_authtoken"    : data.api_authtoken,
//                                 @"authtoken_expiry" : data.authtoken_expiry };
//    
//    [keychain mySetObject:data.email forKey:(__bridge id)kSecAttrAccount];
    [keychain mySetObject:data  forKey:(__bridge id)kSecValueData];
    [keychain writeToKeychain];
}

- (UserAuthResponseModel *)userDataFromKeychain {
    
    KeychainWrapper* keychain = [[KeychainWrapper alloc] init];
    
    UserAuthResponseModel* credentials = [keychain myObjectForKey:(__bridge id)kSecValueData];
    
    return credentials;
}

@end
