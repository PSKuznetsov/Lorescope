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
#import "LSLocalPostProtocol.h"
#import "LSUserProtocol.h"

#import <Realm/Realm.h>
#import <CloudKit/CloudKit.h>


@implementation LSDataSynchronizer

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
        NSMutableArray* recordsToDelete = [NSMutableArray arrayWithCapacity:[[cache objectsForDelete]count]];
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

@end
