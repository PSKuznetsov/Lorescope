//
//  LSServerManager.m
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <AFNetworking.h>
#import "LSServerManager.h"

@interface LSServerManager ()

@property (strong, nonatomic) AFHTTPRequestOperationManager* requestOperationManager;

@end

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

- (instancetype)init
{
    self = [super init];
    if (self) {

        NSURL* baseURL = [NSURL URLWithString:API_BASE_URL];
        _requestOperationManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:baseURL];
        [_requestOperationManager.requestSerializer setAuthorizationHeaderFieldWithUsername:API_AUTH_NAME
                                                                                   password:API_AUTH_PASSWORD];
    }
    return self;
}

#pragma mark - Authentication

//Registering new user with username and password
- (void)userSignUpRequestWithUsername:(NSString *)username
                             password:(NSString *)password
                                email:(NSString *)email
                            onSuccess:(void (^)(NSArray* response)) success
                            onFailure:(void (^)(NSError * error)) failure {
    
    //AES encrypt password for request
    NSString* encryptedPassword = [AESCrypt encrypt:password password:API_AUTH_PASSWORD];
    
    //Configure JSON for POST request
    NSDictionary* requestParametrs = @{@"full_name" :  username,
                                       @"email"     :  email,
                                       @"password"  :  encryptedPassword};
    
    //Perform POST SignUp request to server
    [self.requestOperationManager POST:@"signup"
                            parameters:requestParametrs
                               success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                   
                                   NSLog(@"JSON: %@", responseObject);
                                   
                                   //Saving user data for keychain
                                   [self saveUserDataToKeychain:username password:password];
                                   
                                   if (success) {
                                       //call success block
                                       success(responseObject);
                                   }
                               }
                               failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                   
                                   NSLog(@"ERROR: %@", [error localizedDescription]);
                                   
                                   if (failure) {
                                       //call failure block
                                       failure(error);
                                   }
                               }];
    
    
   
    
}
//Sign in user with username and password
- (void)userSignInRequestWithEmail:(NSString *)email
                             password:(NSString *)password
                            onSuccess:(void (^)(NSArray* response)) success
                            onFailure:(void (^)(NSError * error)) failure {
    //TODO: if fields are nil
    //AES encrypt password for request
    NSString* encryptedPassword = [AESCrypt encrypt:password password:API_AUTH_PASSWORD];
    
    //Configure JSON for POST request
    NSDictionary* requestParametrs = @{@"email"     :  email,
                                       @"password"  :  encryptedPassword};
    
    //NSString* requestParams = [NSString stringWithFormat:@"{\"email\":\"%@\",\"password\":\"%@\"}", email, encryptedPassword];
    //self.requestOperationManager.requestSerializer  = [AFJSONRequestSerializer  serializer];
    //[self.requestOperationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    //[self.requestOperationManager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    
    //Perform POST SignIn request to server
    [self.requestOperationManager POST:@"signin"
                            parameters:requestParametrs
                               success:^(AFHTTPRequestOperation * _Nonnull operation, id  _Nonnull responseObject) {
                                   NSLog(@"JSON: %@", responseObject);
                                   
                                   if (success) {
                                       success(responseObject);
                                   }
                               }
                               failure:^(AFHTTPRequestOperation * _Nonnull operation, NSError * _Nonnull error) {
                                   NSLog(@"ERROR: %@", [error localizedDescription]);
                                   
                                   if (failure) {
                                       failure(error);
                                   }
                               }];
    
}

#pragma mark - Security

- (void)saveUserDataToKeychain:(NSString *)username password:(NSString *)password {
    
    KeychainWrapper* keychain = [[KeychainWrapper alloc]init];
    
    [keychain mySetObject:username forKey:(__bridge id)kSecAttrAccount];
    [keychain writeToKeychain];
    [keychain mySetObject:password forKey:(__bridge id)kSecValueData];
    [keychain writeToKeychain];
}

- (NSDictionary *)userDataFromKeychain {
    //TODO: NSUTF8StringEncoding for password
    KeychainWrapper* keychain = [[KeychainWrapper alloc] init];
    
    NSDictionary* credentials = @{@"username" : [keychain myObjectForKey:(__bridge id)kSecAttrAccount],
                                  @"password" : [keychain myObjectForKey:(__bridge id)kSecValueData]};
    return credentials;
}

@end
