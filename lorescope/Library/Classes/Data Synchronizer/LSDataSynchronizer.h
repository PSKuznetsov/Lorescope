//
//  LSDataSynchronizer.h
//  lorescope
//
//  Created by Paul Kuznetsov on 12/05/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSControllerManipulatorDelegate;
@protocol LSDataSynchronizerProtocol;
@protocol LSDataManipulatorProtocol;
@protocol LSLocalPostManagerProtocol;
@protocol LSRemotePostManagerProtocol;
@protocol LSDataCacherProtocol;
@protocol LSUserProtocol;

@interface LSDataSynchronizer : NSObject <LSDataSynchronizerProtocol>

@property (nonatomic, strong) id <LSControllerManipulatorDelegate> manipulatorDelegate;

- (void)shouldConnectWithUser:(id <LSUserProtocol>)user completionHandler:(void(^)(BOOL success, NSError* error))handler;

- (void)shouldCheckCacheForRecordsForDelete:(id <LSDataCacherProtocol>)cache completionHandler:(void(^)(NSArray* recordsID, NSError* error))handler;

- (void)shouldCheckCacheForRecordsForSave:(id <LSDataCacherProtocol>)cache completionHandler:(void(^)(NSArray* records, NSError* error))handler;

- (void)shouldSynchronizeDataWithCompletionHandler:(void(^)(BOOL success, NSError* error))handler;

- (instancetype)initWithDataManipulator:(id <LSDataManipulatorProtocol>)manipulator;

@end
