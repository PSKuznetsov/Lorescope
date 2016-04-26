//
//  Post.h
//  lorescope
//
//  Created by Paul Kuznetsov on 05/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Realm/Realm.h>
#import "LSLocalPostProtocol.h"

@interface LSLocalPost : RLMObject <LSLocalPostProtocol>

@property (nonatomic, copy) NSString* photoPath;
@property (nonatomic, copy) NSString* postID;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSDate* lastModifiedAt;

@end
