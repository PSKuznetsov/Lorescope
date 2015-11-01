//
//  LSSessionManager.h
//  lorescope
//
//  Created by Paul Kuznetsov on 29/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import "UserSignInRequestModel.h"
#import "UserSignUpRequestModel.h"
#import "UserAuthResponseModel.h"

@interface LSSessionManager : AFHTTPSessionManager

+ (instancetype)sharedManager;

- (NSURLSessionDataTask *)postUserSignInWithRequestModel:(UserSignInRequestModel *)requestModel
                                                 success:(void(^)(UserAuthResponseModel* responseModel))success
                                                 failure:(void(^)(NSError *error))failure;

- (NSURLSessionDataTask *)postUserSignUpWithRequestModel:(UserSignUpRequestModel *)requestModel
                                                 success:(void(^)(UserAuthResponseModel* responseModel))success
                                                 failure:(void(^)(NSError* error))failure;

@end
