//
//  UserSignInRequestModel.m
//  lorescope
//
//  Created by Paul Kuznetsov on 29/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "UserSignInRequestModel.h"

@implementation UserSignInRequestModel

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{ @"email"    : @"email",
              @"password" : @"password" };
}

@end
