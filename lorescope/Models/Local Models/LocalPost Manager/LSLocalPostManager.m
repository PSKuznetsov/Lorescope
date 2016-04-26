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

@implementation LSLocalPostManager

#pragma marj - LSLocalPostManagerProtocol

- (void)saveLocalPostToDB:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success, NSError* error))handler {
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    NSError* error;
    
    LSLocalPost* newPost = [[LSLocalPost alloc]init];
    newPost.content = post.content;
    newPost.photoPath = post.photoPath;
    newPost.postID = post.postID;
    newPost.createdAt = post.createdAt;
    newPost.lastModifiedAt = post.lastModifiedAt;
    
    [realm beginWriteTransaction];
    [realm addObject:newPost];
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
    
    RLMResults* results = [LSLocalPost allObjects];
    
    NSError* error;
    
    if (index > [results count]) {
        
        error = [NSError errorWithDomain:@"Out of Range Exc" code:404 userInfo:nil];
        
        if (handler) {
           handler(nil, error);
        }
        
    } else {
        
        LSLocalPost* newPost = [results objectAtIndex:index];
        
        if (handler) {
            
            handler(newPost, nil);
        }
    }
    
}

- (void)deleteLocalPostFromDB:(id<LSLocalPostProtocol>)post competionHandler:(void(^)(BOOL success, NSError* error))handler {
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    NSError* error;
    
    LSLocalPost* newPost = [[LSLocalPost alloc]init];
    newPost.content = post.content;
    newPost.photoPath = post.photoPath;
    newPost.postID = post.postID;
    newPost.createdAt = post.createdAt;
    newPost.lastModifiedAt = post.lastModifiedAt;
    
    [realm beginWriteTransaction];
    [realm deleteObject:newPost];
    [realm commitWriteTransaction:&error];
    
    if (handler) {
        if (error) handler(NO, error);
        else handler(YES, nil);
    }

}

- (void)updateLocalPostInDB:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success, NSError* error))handler {
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    NSError* error;
    
    LSLocalPost* newPost = [[LSLocalPost alloc]init];
    newPost.content = post.content;
    newPost.photoPath = post.photoPath;
    newPost.postID = post.postID;
    newPost.createdAt = post.createdAt;
    newPost.lastModifiedAt = post.lastModifiedAt;
    
    [realm beginWriteTransaction];
    [realm addOrUpdateObject:newPost];
    [realm commitWriteTransaction:&error];
    
    if (handler) {
        if (error) handler(NO, error);
        else handler(YES, nil);
    }
}

@end
