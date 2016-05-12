//
//  LSRemotePostManager.h
//  lorescope
//
//  Created by Paul Kuznetsov on 25/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSRemotePostProtocol.h"

@protocol LSRemotePostManagerProtocol <NSObject>

#pragma mark - Creat

- (void)createRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success, id<LSRemotePostProtocol> post))handler;

- (void)postWithID:(NSString *)postID completionHandler:(void(^)(id<LSRemotePostProtocol> post, NSError* error))handler;

#pragma mark - Update

- (void)updateRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success))handler;

- (void)updateRemotePostWithID:(id<NSObject>)postID withContent:(id<NSObject>)content completionHandler:(void(^)(BOOL success))handler;

#pragma mark - Delete

- (void)deleteRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success))handler;

- (void)deleteRemotePosts:(NSArray<id<LSRemotePostProtocol>> *)posts completionHandler:(void(^)(BOOL success))handler;

- (void)deleteRemotePostWithID:(id<NSObject>)postID completionHandler:(void(^)(BOOL success))handler;

- (void)deleteRemotePostsWithID:(NSArray<id<NSObject>> *)postsID completionHandler:(void(^)(BOOL success))handler;

#pragma mark - Read

- (void)retrievePostsWithCompletionHandler:(void(^)(NSArray<id<LSRemotePostProtocol>> *posts))handler;

@end
