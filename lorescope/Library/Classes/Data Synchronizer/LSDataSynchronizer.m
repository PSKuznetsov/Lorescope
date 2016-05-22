//
//  LSDataSynchronizer.m
//  lorescope
//
//  Created by Paul Kuznetsov on 12/05/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "LSDataSynchronizer.h"
#import "LSDataSynchronizerProtocol.h"
#import "LSDataCacherProtocol.h"
#import "LSLocalPostManagerProtocol.h"
#import "LSLocalPostProtocol.h"
#import "LSRemotePostManagerProtocol.h"
#import "LSDataManipulatorProtocol.h"
#import "LSControllerManipulatorDelegate.h"
#import "LSUserProtocol.h"
#import "LSLocalPost.h"
#import "LSRemotePost.h"

#import <Realm/Realm.h>
#import <CloudKit/CloudKit.h>

@interface LSDataSynchronizer ()
@property (nonatomic, strong) id <LSDataManipulatorProtocol> dataManipulator;
@end

@implementation LSDataSynchronizer

- (instancetype)initWithDataManipulator:(id <LSDataManipulatorProtocol>)manipulator {
    
    self = [super init];
    if (self) {
        self.dataManipulator = manipulator;
    }
    return self;
}

- (void)shouldConnectWithUser:(id <LSUserProtocol>)user completionHandler:(void(^)(BOOL success, NSError* error))handler {
    
    CKContainer* container = [CKContainer defaultContainer];
    [container fetchUserRecordIDWithCompletionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"iCloud error: %@", error.localizedDescription);
            if (handler) {
                handler(NO, error);
            }
            
        } else {
            
            if (![user.userID isEqual:recordID.recordName]) {
                
                [user saveUserID:recordID.recordName];
                
                NSLog(@"User iCloud ID(updated): %@", user.userID);
                
                //Deleting all previous data from DB
                RLMRealm* realm = [RLMRealm defaultRealm];
                
                [realm beginWriteTransaction];
                [realm deleteAllObjects];
                [realm commitWriteTransaction];
            }
            
            if (handler) {
                handler(YES, nil);
            }
        }
    }];
}

- (void)shouldCheckCacheForRecordsForDelete:(id <LSDataCacherProtocol>)cache completionHandler:(void(^)(NSArray* recordsID, NSError* error))handler {
    
    if ([[cache objectsForDelete] count] > 0) {
        
        NSMutableArray* recordsToDelete = [NSMutableArray array];
        for (id <LSLocalPostProtocol> post in [cache objectsForDelete]) {
            [recordsToDelete addObject:post.postID];
        }
        
        if (handler) {
            handler(recordsToDelete, nil);
        }
    }
    else {
        
        NSError* error;
        if (handler) {
            handler(nil, error);
        }
    }
}

- (void)shouldCheckCacheForRecordsForSave:(id <LSDataCacherProtocol>)cache completionHandler:(void(^)(NSArray* records, NSError* error))handler {
    
    if ([[cache objectsForSave] count] > 0) {
        NSMutableArray* recordsToSave = [NSMutableArray array];
        for (id <LSLocalPostProtocol> post in [cache objectsForSave]) {
            [recordsToSave addObject:post];
        }
        
        if (handler) {
            handler(recordsToSave, nil);
        }
    }
    else {
        NSError* error;
        if (handler) {
            handler(nil, error);
        }
    }
}

- (void)shouldSynchronizeDataWithCompletionHandler:(void(^)(BOOL success, NSError* error))handler {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block NSMutableArray* receivedRemotePosts = [NSMutableArray array];
    __block NSMutableArray* receivedLocalPosts  = [NSMutableArray array];
    __block NSMutableArray* discartedRemotePosts = [NSMutableArray array];
    __block NSMutableArray* discartedLocalPosts  = [NSMutableArray array];
    __block BOOL succeeded = NO;
        
    dispatch_group_enter(group);
    [self.dataManipulator.remoteManager retrievePostsWithCompletionHandler:^(NSArray<id<LSRemotePostProtocol>> *posts) {
        if (posts) {
            receivedRemotePosts = [NSMutableArray arrayWithArray:posts];
            succeeded = YES;
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, queue, ^{
        
        RLMResults* requestedLocalPosts = [LSLocalPost allObjects];
        
        __weak typeof(self) weakSelf = self;
        
        for (LSLocalPost* localPost in requestedLocalPosts) {
            [receivedLocalPosts addObject:localPost];
        }
            //Fetching existing posts in DB
        for (LSRemotePost* remotePost in receivedRemotePosts) {
            for (LSLocalPost* localPost in receivedLocalPosts) {
                if ([remotePost.record.recordID.recordName isEqual:localPost.postID]) {
                    [discartedRemotePosts addObject:remotePost];
                    [discartedLocalPosts  addObject:localPost];
                }
            }
        }
        
        [receivedRemotePosts removeObjectsInArray:discartedRemotePosts];
        [receivedLocalPosts  removeObjectsInArray:discartedLocalPosts];
        
        //Downloading posts which are not on the device
        if ([receivedRemotePosts count] > 0) {
            for (LSRemotePost* remotePost in receivedRemotePosts) {
                [self.dataManipulator shouldSaveRemotePost:remotePost completionHandler:^(BOOL success) {
                        //reload data
                    if (success) {
                        succeeded = YES;
                        [weakSelf.manipulatorDelegate contorllerShouldPerformReloadData:nil];
                    }
                    else {
                        succeeded = NO;
                    }
                }];
            }
        }
            //Deleting leftovers
        if ([receivedLocalPosts count] > 0) {
            for (LSLocalPost* localPost in receivedLocalPosts) {
                [self.dataManipulator.localManager deleteLocalPostFromDBWithPostID:localPost.postID
                                                                  competionHandler:^(BOOL success, NSError *error) {
                                                                          //reload data
                                                                      if (success) {
                                                                          succeeded = YES;
                                                                          [weakSelf.manipulatorDelegate contorllerShouldPerformReloadData:nil];
                                                                      }
                                                                      else {
                                                                          succeeded = NO;
                                                                      }
                                                                  }];
            }
        }
        
        if (handler) {
            handler(succeeded, nil);
        }
    });
}

@end
