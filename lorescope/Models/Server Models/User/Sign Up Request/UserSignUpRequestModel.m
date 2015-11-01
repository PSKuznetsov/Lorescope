//
//  UserSignUpRequestModel.m
//  lorescope
//
//  Created by Paul Kuznetsov on 29/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "UserSignUpRequestModel.h"

@implementation UserSignUpRequestModel

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{ @"full_name" : @"full_name",
              @"email"     : @"email",
              @"password"  : @"password"  };
}


@end
