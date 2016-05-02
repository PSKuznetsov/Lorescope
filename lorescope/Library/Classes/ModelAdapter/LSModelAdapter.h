//
//  LSModelAdapter.h
//  lorescope
//
//  Created by Paul Kuznetsov on 28/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "LSModelAdapterProtocol.h"
@protocol LSRemotePostProtocol;
@protocol LSLocalPostProtocol;

@interface LSModelAdapter : NSObject <LSModelAdapterProtocol>

- (void)shouldAdaptLocalModel:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(id<LSRemotePostProtocol> remotePost, NSError* error))handler;
- (void)shouldAdaptRemoteModel:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(id<LSLocalPostProtocol> localPost, NSError* error))handler;

@end
