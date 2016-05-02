//
//  LSModelAdapter.m
//  lorescope
//
//  Created by Paul Kuznetsov on 28/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "LSModelAdapter.h"
#import "LSModelAdapterProtocol.h"
#import "LSLocalPostProtocol.h"
#import "LSRemotePostProtocol.h"

#import "LSRemotePost.h"
#import "LSLocalPost.h"

@implementation LSModelAdapter
    //Use only for creating new remote models. Do not use with update methods
- (void)shouldAdaptLocalModel:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(id<LSRemotePostProtocol> remotePost, NSError* error))handler {
    
    LSRemotePost* remotePost = [[LSRemotePost alloc]initWithRecord:[[CKRecord alloc]initWithRecordType:@"Post"]];
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:post.photoPath];
    
    remotePost.content = post.content;
    CKAsset* img = [[CKAsset alloc]initWithFileURL:[NSURL fileURLWithPath:path]];
    remotePost.imageData = img;
    
    if (handler) {
        
        if (remotePost.content != nil && remotePost.imageData != nil) {
            handler(remotePost, nil);
            NSLog(@"Adapt completed!");
        }
        else {
            
            NSError* error = [[NSError alloc]initWithDomain:NSCocoaErrorDomain code:404 userInfo:nil];
            handler(nil, error);
        }
    }
    
}

- (void)shouldAdaptRemoteModel:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(id<LSLocalPostProtocol> localPost, NSError* error))handler {
    
    LSLocalPost* localPost = [[LSLocalPost alloc]init];
    
    localPost.content   = post.content;
    localPost.photoPath = [post.imageData.fileURL path];
    localPost.postID    = post.postID;
    localPost.createdAt = post.createdAt;
    localPost.lastModifiedAt = post.lastModifiedAt;
    
    if (handler) {
        
        if (localPost.photoPath && localPost.content) {
            handler(localPost, nil);
        }
        else {
            
            NSError* error = [NSError errorWithDomain:NSCocoaErrorDomain code:404 userInfo:nil];
            handler(nil, error);
        }
    }
    
}

@end
