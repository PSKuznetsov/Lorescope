//
//  LSRemotePostManager.m
//  lorescope
//
//  Created by Paul Kuznetsov on 25/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "LSRemotePostManager.h"
#import "LSRemotePost.h"

@interface LSRemotePostManager ()
@property (nonatomic, strong) CKDatabase* database;
@end

@implementation LSRemotePostManager

#pragma mark - Initialization

- (instancetype)initWithDatabase:(CKDatabase *)database {
    self = [super init];
    if (self) {
        
        self.database = database;
    }
    return self;
}

#pragma mark - Methods

- (void)createRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success, id<LSRemotePostProtocol>post))handler {
    
    LSRemotePost* remotePost = [[LSRemotePost alloc]initWithPost:post];
    [self.database saveRecord:remotePost.record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
            
            NSLog(@"%@", error.localizedDescription);
            if (handler) handler(false, nil);
        }
        else {
            
            NSLog(@"Record saved successesfully!");
            if (handler) handler(true, remotePost);
        }
    }];
}

- (void)postWithID:(NSString *)postID completionHandler:(void(^)(id<LSRemotePostProtocol>post))handler {
    
    CKRecordID* recordID = [[CKRecordID alloc]initWithRecordName:postID];
    [self.database fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
           
            NSLog(@"%@", error.localizedDescription);
            handler(nil);
        }
        else {
            
            LSRemotePost* post = [[LSRemotePost alloc]initWithRecord:record];
            handler(post);
        }
    }];
}

- (void)updateRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success, id<LSRemotePostProtocol>post))handler {
    
}

- (void)deleteRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success))handler {
    
}

@end
