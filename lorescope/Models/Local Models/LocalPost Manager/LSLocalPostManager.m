//
//  LSLocalPostManager.m
//  lorescope
//
//  Created by Paul Kuznetsov on 26/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//
#import <Realm/Realm.h>
#import "LSLocalPost.h"
#import "LSLocalPostManager.h"

@interface LSLocalPostManager ()
@property (nonatomic, assign, readwrite) NSUInteger postsCount;
@end

@implementation LSLocalPostManager

#pragma mark - Initialize

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.postsCount = [[LSLocalPost allObjects] count];
    }
    return self;
}

#pragma marj - LSLocalPostManagerProtocol

- (void)saveLocalPostToDB:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success, NSError* error))handler {
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    NSError* error;
    
    [realm beginWriteTransaction];
    [realm addObject:post];
    [realm commitWriteTransaction:&error];
    
    if (handler) {
        
        if (error) {
            
            handler(NO, error);
        }
        else {            
            handler(YES, nil);
        }
    }
    
}

- (void)postWithIndexInDB:(NSUInteger)index completionHandler:(void(^)(id<LSLocalPostProtocol> post, NSError* error))handler {
    
    RLMResults* results = [[LSLocalPost allObjects] sortedResultsUsingProperty:@"createdAt" ascending:NO];
    
    NSError* error;
    
    if (index > [results count]) {
        
        error = [NSError errorWithDomain:@"Out of Range Exc" code:404 userInfo:nil];
        
        if (handler) {
           handler(nil, error);
        }
        
    } else {
        
        id <LSLocalPostProtocol> newPost = [results objectAtIndex:index];
        
        if (handler) {
            
            handler(newPost, nil);
        }
    }
    
}

- (void)deleteLocalPostFromDB:(id<LSLocalPostProtocol>)post competionHandler:(void(^)(BOOL success, NSError* error))handler {
    
    RLMRealm* realm = [RLMRealm defaultRealm];
//    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"postID = %@", post.postID];
//    LSLocalPost* postToDelete = [[LSLocalPost objectsWithPredicate:predicate]firstObject];
    
    NSError* error;
    
    [realm beginWriteTransaction];
    [realm deleteObject:post];
    [realm commitWriteTransaction:&error];
    
    if (handler) {
        
        if (error) {
            
            handler(NO, error);
        }
        else {
            
            handler(YES, nil);
        }
    }
    
}

- (void)updateLocalPost:(id<LSLocalPostProtocol>)post withContent:(id<NSObject>)content completionHandler:(void(^)(BOOL success, NSError* error))handler {
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    NSError* error;
    
    [realm beginWriteTransaction];
    post.content = (NSString *)content;
    [realm commitWriteTransaction:&error];
    
    if (handler) {
        
        if (error) {
            
            handler(NO, error);
        }
        else {
            handler(YES, nil);
        }
    }
}

- (void)updateLocalPost:(id<LSLocalPostProtocol>)post withPostID:(id<NSObject>)postID completionHandler:(void(^)(BOOL success, NSError* error))handler {
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    NSError* error;
    
    [realm beginWriteTransaction];
    post.postID = (NSString *)postID;
    [realm commitWriteTransaction:&error];
    
    if (handler) {
        
        if (error) {
            
            handler(NO, error);
        }
        else {
            handler(YES, nil);
        }
    }
}

#pragma mark - Utils

- (void)updatePostsCount {
    NSLog(@"Count updated: %lu", (unsigned long)self.postsCount);
    self.postsCount = [[LSLocalPost allObjects] count];
}

@end
