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

- (void)createRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success, id<LSRemotePostProtocol>post))handler;

- (void)postWithID:(NSString *)postID completionHandler:(void(^)(id<LSRemotePostProtocol>post))handler;

- (void)updateRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success, id<LSRemotePostProtocol>post))handler;

- (void)deleteRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success))handler;

@end
