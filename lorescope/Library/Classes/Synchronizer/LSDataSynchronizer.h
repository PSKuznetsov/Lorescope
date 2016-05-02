//
//  LSDataSynchronizer.h
//  lorescope
//
//  Created by Paul Kuznetsov on 26/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDataSynchronizerProtocol.h"
@protocol LSLocalPostManagerProtocol;
@protocol LSRemotePostManagerProtocol;
@protocol LSModelAdapterProtocol;

@interface LSDataSynchronizer : NSObject <LSDataSynchronizerProtocol>

@property (nonatomic, strong) id <LSRemotePostManagerProtocol> remoteManager;
@property (nonatomic, strong) id <LSLocalPostManagerProtocol> localManager;

@property (nonatomic, strong) id <LSModelAdapterProtocol> adapter;

- (void)shouldSaveLocalPost: (id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success))handler;
- (void)shouldDeleteLocalPost:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success))handler;
- (void)shouldUpdateLocalPost:(id<LSLocalPostProtocol>)post withContent:(id<NSObject>)content completionHandler:(void(^)(BOOL success))handler;
- (NSUInteger)countOfLocalPosts;

@end
