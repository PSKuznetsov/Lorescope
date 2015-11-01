//
//  UserAuthResponseModel.h
//  lorescope
//
//  Created by Paul Kuznetsov on 29/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UserAuthResponseModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, strong) NSString* api_authtoken;
@property (nonatomic, strong) NSDate*   authtoken_expiry;
@property (nonatomic, strong) NSString* email;
@property (nonatomic, strong) NSString* first_name;
@property (nonatomic, strong) NSString* last_name;

+ (NSDictionary *)JSONKeyPathsByPropertyKey;

@end
