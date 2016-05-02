//
//  LSPostProtocol.h
//  lorescope
//
//  Created by Paul Kuznetsov on 25/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>

@protocol LSRemotePostProtocol <NSObject>

@property (nonatomic, copy) NSString* postID;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, strong) CKAsset* imageData;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSDate* lastModifiedAt;
@property (nonatomic, strong) CKRecord* record;

@end
