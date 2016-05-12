//
//  LSRemotePostManager.h
//  lorescope
//
//  Created by Paul Kuznetsov on 25/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CloudKit/CloudKit.h>
#import "LSRemotePostManagerProtocol.h"

@interface LSRemotePostManager : NSObject <LSRemotePostManagerProtocol>

- (instancetype)initWithDatabase:(CKDatabase *)database;

- (void)createRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success, id<LSRemotePostProtocol> post))handler;

- (void)postWithID:(NSString *)postID completionHandler:(void(^)(id<LSRemotePostProtocol> post, NSError* error))handler;

- (void)updateRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success))handler;

- (void)updateRemotePostWithID:(id<NSObject>)postID withContent:(id<NSObject>)content completionHandler:(void(^)(BOOL success))handler;

- (void)deleteRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success))handler;

- (void)deleteRemotePosts:(NSArray<id<LSRemotePostProtocol>> *)posts completionHandler:(void(^)(BOOL success))handler;

- (void)deleteRemotePostWithID:(id<NSObject>)postID completionHandler:(void(^)(BOOL success))handler;

- (void)deleteRemotePostsWithID:(NSArray<id<NSObject>> *)postsID completionHandler:(void(^)(BOOL success))handler;

- (void)retrievePostsWithCompletionHandler:(void(^)(NSArray<id<LSRemotePostProtocol>> *posts))handler;


@end