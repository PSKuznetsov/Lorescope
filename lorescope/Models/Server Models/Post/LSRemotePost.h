//
//  LSPostRemote.h
//  lorescope
//
//  Created by Paul Kuznetsov on 25/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "LSRemotePostProtocol.h"

@interface LSRemotePost : NSObject <LSRemotePostProtocol>

@property (nonatomic, copy) NSString* postID;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, strong) NSData* imageData;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSDate* lastModifiedAt;
@property (nonatomic, strong) CKRecord* record;
@property (nonatomic, assign) NSInteger age;

- (instancetype)initWithRecord:(CKRecord *)record;
- (instancetype)initWithPost:(id <LSRemotePostProtocol>)post;

@end
