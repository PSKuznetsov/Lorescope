//
//  LSModelAdapterProtocol.h
//  lorescope
//
//  Created by Paul Kuznetsov on 28/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSLocalPostProtocol;
@protocol LSRemotePostProtocol;

@protocol LSModelAdapterProtocol <NSObject>

- (void)shouldAdaptLocalModel:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(id<LSRemotePostProtocol> remotePost, NSError* error))handler;
- (void)shouldAdaptRemoteModel:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(id<LSLocalPostProtocol> localPost, NSError* error))handler;

@end
