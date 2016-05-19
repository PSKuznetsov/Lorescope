//
//  LSDataSynchronizer.m
//  lorescope
//
//  Created by Paul Kuznetsov on 26/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <CloudKit/CloudKit.h>

#import "LSDataManipulatorProtocol.h"
#import "LSDataManipulator.h"

#import "LSRemotePostManager.h"
#import "LSLocalPostManager.h"

#import "LSDataCacherProtocol.h"
#import "LSDataCacher.h"

#import "LSModelAdapterProtocol.h"
#import "LSModelAdapter.h"

#import "LSLocalPost.h"
#import "LSRemotePost.h"

@implementation LSDataManipulator

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.remoteManager = [[LSRemotePostManager alloc]initWithDatabase:[[CKContainer defaultContainer]privateCloudDatabase]];
        self.localManager  = [[LSLocalPostManager alloc]init];
        self.adapter       = [[LSModelAdapter alloc]init];
        self.cacher        = [[LSDataCacher alloc]init];
    }
    return self;
}

#pragma mark - LSDataSynchronizerProtocol

- (void)shouldSaveLocalPost:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success))handler {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block id <LSRemotePostProtocol> adaptedPost;
    __block id <LSRemotePostProtocol> savedRemotePost;
    __block BOOL succeeded = NO;
    
    dispatch_group_enter(group);
    
    [self.adapter shouldAdaptLocalModel:post completionHandler:^(id<LSRemotePostProtocol> remotePost, NSError *error) {
        
        if (!error) {
            adaptedPost = remotePost;
            succeeded = YES;
        }
        else {
            NSLog(@"Can't adapt local model!");
            succeeded = NO;
        }
        dispatch_group_leave(group);
        
    }];
    
    dispatch_group_enter(group);
    
    if (succeeded) {
        
        [self.remoteManager createRemotePost:adaptedPost completionHandler:^(BOOL success, id<LSRemotePostProtocol> post) {
            
            if (success) {
                
                savedRemotePost = post;
                NSLog(@"Remote post created!");
                succeeded = YES;
            }
            else {
                NSLog(@"Manager can't save post remotely!");
                succeeded = NO;
                    //[self.cacher shouldCacheObjectMarkedForSave:post];
            }
            
            dispatch_group_leave(group);
            
        }];
    }
    
    dispatch_group_notify(group, queue, ^{
        
        post.postID = savedRemotePost.postID;
        post.createdAt = savedRemotePost.createdAt;
        post.lastModifiedAt = savedRemotePost.lastModifiedAt;
        
        [self.localManager saveLocalPostToDB:post completionHandler:^(BOOL success, NSError *error) {
            
            if (success) {
                
            }
            else {
                succeeded = NO;
            }
            
        }];
        
        handler(succeeded);
    });
    
}

- (void)shouldDeleteLocalPost:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success))handler {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block BOOL succeeded = NO;
    __block id<LSRemotePostProtocol> remotePost;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"postID = %@", post.postID];
    
    dispatch_group_enter(group);
    [self.remoteManager postWithID:post.postID completionHandler:^(id<LSRemotePostProtocol> post, NSError *error) {
        
        if (!error) {
            remotePost = post;
            succeeded = YES;
        }
        
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    
        [self.remoteManager deleteRemotePost:remotePost completionHandler:^(BOOL success) {
            
            if (success) {
                succeeded = YES;
                NSLog(@"Remote post deleted!");
            }
            else {
                NSLog(@"Remote post doesn't deleted!");
                succeeded = NO;
                    //[self.cacher shouldCacheObjectMarkedForDelete:post];
            }
            dispatch_group_leave(group);
        }];
    
    dispatch_group_notify(group, queue, ^{
        
        LSLocalPost* postToDelete = [[LSLocalPost objectsWithPredicate:predicate]firstObject];
        
        [self.localManager deleteLocalPostFromDB:postToDelete competionHandler:^(BOOL success, NSError *error) {
           
            if (success) {
                NSLog(@"Local post deleted!");
                succeeded = YES;
                
            }
            else {
                NSLog(@"Local post can't be deleted!");
                succeeded = NO;
            }
            
        }];
        
        handler(succeeded);
        
    });
}

- (void)shouldUpdateLocalPost:(id<LSLocalPostProtocol>)post withContent:(id<NSObject>)content completionHandler:(void(^)(BOOL success))handler {

    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block BOOL successeded = NO;
    __block NSString* updatedContent = (NSString *)content;
    
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"postID = %@", post.postID];
    NSLog(@"Local postID = %@", post.postID);
    
    dispatch_group_enter(group);
    [self.remoteManager updateRemotePostWithID:post.postID
                                   withContent:updatedContent
                             completionHandler:^(BOOL success) {
                                 
                                 if (success) {
                                     NSLog(@"Remote post updated!");
                                     successeded = YES;
                                     
                                 }
                                 else {
                                     successeded = NO;
                                     NSLog(@"Remote post failure for update!");
                                         //[self.cacher shouldCacheObjectMarkedForSave:post];
                                 }
                                 dispatch_group_leave(group);
                             }];
    
    
    dispatch_group_notify(group, queue, ^{
        
        if (successeded) {
            
            LSLocalPost* postForUpdate = [[LSLocalPost objectsWithPredicate:predicate]firstObject];
            
            [self.localManager updateLocalPost:postForUpdate
                                   withContent:content
                             completionHandler:^(BOOL success, NSError *error) {
                                 
                                 if (success) {
                                     successeded = YES;
                                     NSLog(@"Local post updated!");
                                 }
                                 else {
                                     successeded = NO;
                                     NSLog(@"Can't update local post!");
                                 }
                                 handler(successeded);
                             }];
        }
        else {
            
            NSLog(@"Failure update remote post and can't update local post!");
            handler(successeded);
        }
        
    });
    
}

- (void)shouldSaveRemotePost: (id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success))handler {
    
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    __block id <LSLocalPostProtocol> adaptedPost;
    __block BOOL succeeded = NO;
    
    dispatch_group_enter(group);
    
    [self.adapter shouldAdaptRemoteModel:post completionHandler:^(id<LSLocalPostProtocol> localPost, NSError *error) {
        
        if (!error) {
            adaptedPost = localPost;
            succeeded = YES;
            NSLog(@"Remote post adapted!");
            NSLog(@"Record name - %@", localPost.postID);
        }
        else {
            NSLog(@"Can't adapt remote model: %@", error.localizedDescription);
            succeeded = NO;
        }
        
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, queue, ^{
        
        if (succeeded) {
            
            [self.localManager saveLocalPostToDB:adaptedPost completionHandler:^(BOOL success, NSError *error) {
                
                if (success) {
                    succeeded = YES;
                    NSLog(@"Local post saved!");
                }
                else {
                    succeeded = NO;
                    NSLog(@"Cant save local post: %@", error.localizedDescription);
                }
                
            }];
            
            if (handler) {
                handler(succeeded);
            }
        }
        else {
            
            if (handler) {
                handler(succeeded);
            }
        }
    });

    
}

- (void)shouldDeleteRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success))handler {
    
}

- (void)shouldUpdateRemotePost:(id<LSRemotePostProtocol>)post withContent:(id<NSObject>)content completionHandler:(void(^)(BOOL success))handler {
    
}

- (void)shouldDownloadPostsCompletionHandler:(void(^)(BOOL success))handler {
    
    [self.remoteManager retrievePostsWithCompletionHandler:^(NSArray<id<LSRemotePostProtocol>> *posts) {
        for (LSRemotePost* remotePost in posts) {
            
            [self.adapter shouldAdaptRemoteModel:remotePost completionHandler:^(id<LSLocalPostProtocol> localPost, NSError *error) {
                
                [self.localManager saveLocalPostToDB:localPost completionHandler:^(BOOL success, NSError *error) {
                    
                }];
            }];
        }
    }];
}

- (NSUInteger)countOfLocalPosts {
    
    return [self.localManager postsCount];
}

@end
