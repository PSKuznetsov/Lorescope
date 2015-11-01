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
    self = [super initWithBaseURL:[NSURL URLWithString:API_BASE_URL]];
    if (!self) return nil;
        
    self.requestSerializer  = [AFJSONRequestSerializer  serializer];
    self.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //HTTP Basic Auth to the server
    [self.requestSerializer setAuthorizationHeaderFieldWithUsername:API_AUTH_NAME
                                                           password:API_AUTH_PASSWORD];

    return self;
}

#pragma mark - Authentication

- (NSURLSessionDataTask *)postUserSignInWithRequestModel:(UserSignInRequestModel *)requestModel
                                                 success:(void(^)(UserAuthResponseModel* responseModel))success
                                                 failure:(void(^)(NSError *error))failure {
    
    NSDictionary* requestParameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    
    return [self POST:@"signin" parameters:requestParameters
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                  
                  NSDictionary* responseDictionary = (NSDictionary *)responseObject;
                  NSError* error = nil;
                  
                  NSLog(@"%@", responseDictionary);
                  
                  UserAuthResponseModel* responseModel = [MTLJSONAdapter modelOfClass:UserAuthResponseModel.class
                                                                   fromJSONDictionary:responseDictionary
                                                                                error:&error];
                  success(responseModel);
                  
              } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                  
                  failure(error);
              }];
    
}

- (NSURLSessionDataTask *)postUserSignUpWithRequestModel:(UserSignUpRequestModel *)requestModel
                                                 success:(void(^)(UserAuthResponseModel* responseModel))success
                                                 failure:(void(^)(NSError* error))failure {
    
    NSDictionary* requestParameters = [MTLJSONAdapter JSONDictionaryFromModel:requestModel error:nil];
    
    return [self POST:@"signup" parameters:requestParameters
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
                  
                  NSDictionary* responseDictionary = (NSDictionary *)responseObject;
                  NSError* error = nil;
                  
                  UserAuthResponseModel* responseModel = [MTLJSONAdapter modelOfClass:UserAuthResponseModel.class
                                                                   fromJSONDictionary:responseDictionary
                                                                                error:&error];
                  success(responseModel);
                  
              } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
                  
                  failure(error);
              }];
    
}


@end
