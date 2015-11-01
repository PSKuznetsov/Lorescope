//
//  UserSignUpRequestModel.h
//  lorescope
//
//  Created by Paul Kuznetsov on 29/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface UserSignUpRequestModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy) NSString* full_name;
@property (nonatomic, copy) NSString* email;
@property (nonatomic, copy) NSString* password;

+ (NSDictionary *)JSONKeyPathsByPropertyKey;

@end
