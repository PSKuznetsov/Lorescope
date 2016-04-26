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

- (void)createRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success, id<LSRemotePostProtocol>post))handler;

- (void)postWithID:(NSString *)postID completionHandler:(void(^)(id<LSRemotePostProtocol>post))handler;

- (void)updateRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success, id<LSRemotePostProtocol>post))handler;

- (void)deleteRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success))handler;

@end