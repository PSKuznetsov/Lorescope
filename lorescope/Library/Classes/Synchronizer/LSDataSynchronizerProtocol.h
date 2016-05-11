//
//  LSDataSynchronizerProtocol.h
//  lorescope
//
//  Created by Paul Kuznetsov on 26/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSRemotePostManagerProtocol;
@protocol LSLocalPostManagerProtocol;
@protocol LSLocalPostProtocol;
@protocol LSRemotePostProtocol;

@protocol LSDataSynchronizerProtocol <NSObject>

@property (nonatomic, strong) id <LSRemotePostManagerProtocol> remoteManager;
@property (nonatomic, strong) id <LSLocalPostManagerProtocol> localManager;

- (void)shouldSaveLocalPost: (id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success))handler;
- (void)shouldDeleteLocalPost:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success))handler;
- (void)shouldUpdateLocalPost:(id<LSLocalPostProtocol>)post withContent:(id<NSObject>)content completionHandler:(void(^)(BOOL success))handler;
- (NSUInteger)countOfLocalPosts;
- (void)shouldDownloadPostsCompletionHandler:(void(^)(BOOL success))handler;

@end
