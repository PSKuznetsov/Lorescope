//
//  LSLocalPostManager.h
//  lorescope
//
//  Created by Paul Kuznetsov on 26/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSLocalPostManagerProtocol.h"

@interface LSLocalPostManager : NSObject <LSLocalPostManagerProtocol>

@property (nonatomic, assign, readonly) NSUInteger postsCount;

- (void)saveLocalPostToDB:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success, NSError* error))handler;
- (void)postWithIndexInDB:(NSUInteger)index completionHandler:(void(^)(id<LSLocalPostProtocol> post, NSError* error))handler;
- (void)deleteLocalPostFromDB:(id<LSLocalPostProtocol>)post competionHandler:(void(^)(BOOL success, NSError* error))handler;
- (void)updateLocalPost:(id<LSLocalPostProtocol>)post withContent:(id<NSObject>)content completionHandler:(void(^)(BOOL success, NSError* error))handler;
- (void)updateLocalPost:(id<LSLocalPostProtocol>)post withPostID:(id<NSObject>)postID completionHandler:(void(^)(BOOL success, NSError* error))handler;
- (void)updatePostsCount;

@end
