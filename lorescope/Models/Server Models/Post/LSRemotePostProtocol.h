//
//  LSPostProtocol.h
//  lorescope
//
//  Created by Paul Kuznetsov on 25/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSRemotePostProtocol <NSObject>

@property (nonatomic, copy) NSString* postID;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, strong) NSData* imageData;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSDate* lastModifiedAt;

@end
