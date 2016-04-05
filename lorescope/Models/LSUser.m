//
//  LSUser.m
//  lorescope
//
//  Created by Paul Kuznetsov on 25/03/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "LSUser.h"
#import "KeychainWrapper.h"

@interface LSUser ()

@property (nonatomic, strong, readwrite) NSString* userID;
@property (nonatomic, strong, readwrite) NSString* firstname;
@property (nonatomic, strong, readwrite) NSString* lastname;

@property (nonatomic, strong) KeychainWrapper* keychain;

@end

@implementation LSUser

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.keychain = [[KeychainWrapper alloc] init];
        
        self.userID = [self.keychain myObjectForKey:(__bridge id)kSecValueData];
    }
    return self;
}

- (void)saveUserID:(NSString *)uuid {
    
    [self.keychain mySetObject:uuid forKey:(__bridge id)kSecValueData];
    self.userID = uuid;
}


@end
