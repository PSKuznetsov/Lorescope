//
//  LSDataSynchronizer.h
//  lorescope
//
//  Created by Paul Kuznetsov on 12/05/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSDataSynchronizerProtocol;
@protocol LSDataCacherProtocol;
@protocol LSUserProtocol;

@interface LSDataSynchronizer : NSObject <LSDataSynchronizerProtocol>

- (void)shouldConnectWithUser:(id <LSUserProtocol>)user completionHandler:(void(^)(BOOL success, NSError* error))handler;
- (void)shouldCheckCache:(id <LSDataCacherProtocol>)cache completionHandler:(void(^)(BOOL success, NSError* error))handler;

@end
