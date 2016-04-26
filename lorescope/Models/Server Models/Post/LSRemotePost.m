//
//  LSPostRemote.m
//  lorescope
//
//  Created by Paul Kuznetsov on 25/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//
#import <CloudKit/CloudKit.h>
#import "LSRemotePost.h"

@interface LSRemotePost ()

@end

@implementation LSRemotePost

#pragma mark - Initialization

- (instancetype)initWithRecord:(CKRecord *)record {
    
    self = [super init];
    if (self) {
        self.record = record;
    }
    return self;
}
- (instancetype)initWithPost:(id <LSRemotePostProtocol>)post {
    
    self = [super init];
    if (self) {
        self.record = [[CKRecord alloc]initWithRecordType:@"Post"];
        self.content = post.content;
        self.imageData = post.imageData;
    }
    return self;
}

#pragma mark - Accessors

- (NSString *)content {
    
    NSString* content = [self.record objectForKey:@"content"];
    return content;
}

- (void)setContent:(NSString *)content {
    
    [self.record setObject:content forKey:@"content"];
}

- (NSData *)imageData {
    
    NSData * imageData = [self.record objectForKey:@"imageData"];
    return imageData;
}

- (void)setImageData:(NSData *)imageData {
    
    [self.record setObject:imageData forKey:@"imageData"];
}

- (NSString *)postID {
    
    return self.record.recordID.recordName;
}

- (NSDate *)createdAt {
    
    return self.record.creationDate;
}

- (NSDate *)lastModifiedAt {
    
    return self.record.modificationDate;
}

@end
