//
//  UserAuthResponseModel.m
//  lorescope
//
//  Created by Paul Kuznetsov on 29/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import "UserAuthResponseModel.h"

@implementation UserAuthResponseModel

#pragma mark - MTLJSONSerializing

+ (NSDictionary *)JSONKeyPathsByPropertyKey {
    
    return @{ @"api_authtoken"    : @"api_authtoken",
              @"authtoken_expiry" : @"authtoken_expiry",
              @"email"            : @"email",
              @"first_name"       : @"first_name",
              @"last_name"        : @"last_name"         };
}

//+ (NSDateFormatter *)dateFormatter {
//   
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    
//    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
//    dateFormatter.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss'Z'";
//    
//    return dateFormatter;
//}

@end