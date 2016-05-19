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
    
        //LSRemotePost* remotePost = [[LSRemotePost alloc]initWithPost:post];
    [self.database saveRecord:post.record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
            
            NSLog(@"%@", error.localizedDescription);
            if (handler) handler(false, nil);
        }
        else {
            
            NSLog(@"Record saved successesfully!");
            if (handler) handler(true, post);
        }
    }];
}

- (void)postWithID:(NSString *)postID completionHandler:(void(^)(id<LSRemotePostProtocol>post, NSError* error))handler {
    
    CKRecordID* recordID = [[CKRecordID alloc]initWithRecordName:postID];
    [self.database fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        if (error) {
           
            NSLog(@"%@", error.localizedDescription);
            handler(nil, error);
        }
        else {
            
            LSRemotePost* post = [[LSRemotePost alloc]initWithRecord:record];
            handler(post, nil);
        }
    }];
}

- (void)updateRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success))handler {
    
    CKModifyRecordsOperation* operation = [[CKModifyRecordsOperation alloc]initWithRecordsToSave:@[post.record] recordIDsToDelete:nil];
    operation.perRecordCompletionBlock = ^(CKRecord * __nullable record, NSError * __nullable error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    };
    
    operation.modifyRecordsCompletionBlock = ^(NSArray <CKRecord *> * __nullable savedRecords, NSArray <CKRecordID *> * __nullable deletedRecordIDs,
                                               NSError * __nullable operationError) {
        
        if (operationError) {
            
            NSLog(@"%@", operationError.localizedDescription);
            
            if (operationError.code == CKErrorPartialFailure) {
                NSLog(@"There was a problem completing the operation. The following records had problems: %@",[operationError.userInfo objectForKey:CKPartialErrorsByItemIDKey]);
            }
            
            if (handler) {
                
                handler(NO);
            }
            
        } else {
            
            if (handler) {
                
                handler(YES);
            }
        }
    };
    [self.database addOperation:operation];
    
}

- (void)updateRemotePostWithID:(id<NSObject>)postID withContent:(id<NSObject>)content completionHandler:(void(^)(BOOL success))handler {
    
    [self postWithID:(NSString *)postID completionHandler:^(id<LSRemotePostProtocol> post, NSError *error) {
       
        post.content = (NSString *)content;
        
        CKModifyRecordsOperation* operation = [[CKModifyRecordsOperation alloc]initWithRecordsToSave:@[post.record] recordIDsToDelete:nil];
        operation.perRecordCompletionBlock = ^(CKRecord * __nullable record, NSError * __nullable error) {
            
            if (error) {
                NSLog(@"%@", error.localizedDescription);
            }
        };
        
        operation.modifyRecordsCompletionBlock = ^(NSArray <CKRecord *> * __nullable savedRecords, NSArray <CKRecordID *> * __nullable deletedRecordIDs,
                                                   NSError * __nullable operationError) {
            
            if (operationError) {
                
                NSLog(@"%@", operationError.localizedDescription);
                
                if (operationError.code == CKErrorPartialFailure) {
                    NSLog(@"There was a problem completing the operation. The following records had problems: %@",[operationError.userInfo objectForKey:CKPartialErrorsByItemIDKey]);
                }
                
                if (handler) {
                    
                    handler(NO);
                }
                
            } else {
                
                if (handler) {
                    
                    handler(YES);
                }
            }
        };
        [self.database addOperation:operation];
    }];
}

- (void)deleteRemotePost:(id<LSRemotePostProtocol>)post completionHandler:(void(^)(BOOL success))handler {
    
    //LSRemotePost* remotePost = [[LSRemotePost alloc]initWithPost:post];
    CKRecordID* recordIDToDelete = [[CKRecordID alloc] initWithRecordName:post.postID];
    
    [self.database saveRecord:post.record completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
        [self.database deleteRecordWithID:recordIDToDelete completionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
            if (!error) {
                if (handler) {
                    handler(YES);
                }
            }
            else {
                if (handler) {
                    handler(NO);
                }
            }
        }];
    }];
}

- (void)deleteRemotePosts:(NSArray<id<LSRemotePostProtocol>> *)posts completionHandler:(void(^)(BOOL success))handler {
    
    NSMutableArray<CKRecordID *> *recordsToDelete = [@[]mutableCopy]; //very bad practice ;)
    
    for (id<LSRemotePostProtocol> record in posts) {
        CKRecordID* recordToDelete = [[CKRecordID alloc] initWithRecordName:record.postID];
        [recordsToDelete addObject:recordToDelete];
    }
    
    CKModifyRecordsOperation* operation = [[CKModifyRecordsOperation alloc]initWithRecordsToSave:nil recordIDsToDelete:recordsToDelete];
    operation.perRecordCompletionBlock = ^(CKRecord * __nullable record, NSError * __nullable error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    };
    
    operation.modifyRecordsCompletionBlock = ^(NSArray <CKRecord *> * __nullable savedRecords, NSArray <CKRecordID *> * __nullable deletedRecordIDs,
                                               NSError * __nullable operationError) {
        if (operationError) {
            
            if (operationError.code == CKErrorPartialFailure) {
                NSLog(@"There was a problem completing the operation. The following records had problems: %@",
                      [operationError.userInfo objectForKey:CKPartialErrorsByItemIDKey]);
            }
            
            if (handler) {
                
                handler(NO);
            }
            
        } else {
            
            if (handler) {
                
                handler(YES);
            }
        }
    };
    [self.database addOperation:operation];
}

- (void)deleteRemotePostWithID:(id<NSObject>)postID completionHandler:(void(^)(BOOL success))handler {
    
    CKRecordID* recordToDelete = [[CKRecordID alloc] initWithRecordName:(NSString *)postID];
    
    CKModifyRecordsOperation* operation = [[CKModifyRecordsOperation alloc]initWithRecordsToSave:nil recordIDsToDelete:@[recordToDelete]];
    operation.perRecordCompletionBlock = ^(CKRecord * __nullable record, NSError * __nullable error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    };
    
    operation.modifyRecordsCompletionBlock = ^(NSArray <CKRecord *> * __nullable savedRecords, NSArray <CKRecordID *> * __nullable deletedRecordIDs,
                                               NSError * __nullable operationError) {
        if (operationError) {
            
            if (operationError.code == CKErrorPartialFailure) {
                NSLog(@"There was a problem completing the operation. The following records had problems: %@",
                      [operationError.userInfo objectForKey:CKPartialErrorsByItemIDKey]);
            }
            
            if (handler) {
                
                handler(NO);
            }
            
        } else {
            
            if (handler) {
                
                handler(YES);
            }
        }
    };
    [self.database addOperation:operation];
}

- (void)deleteRemotePostsWithID:(NSArray<id<NSObject>> *)postsID completionHandler:(void(^)(BOOL success))handler {
    
    NSMutableArray<CKRecordID *> *recordsToDelete = [@[]mutableCopy]; //very bad practice ;)
    
    for (NSString* recordID in postsID) {
        CKRecordID* recordToDelete = [[CKRecordID alloc] initWithRecordName:recordID];
        [recordsToDelete addObject:recordToDelete];
    }
    
    CKModifyRecordsOperation* operation = [[CKModifyRecordsOperation alloc]initWithRecordsToSave:nil recordIDsToDelete:recordsToDelete];
    operation.perRecordCompletionBlock = ^(CKRecord * __nullable record, NSError * __nullable error) {
        
        if (error) {
            NSLog(@"%@", error.localizedDescription);
        }
    };
    
    operation.modifyRecordsCompletionBlock = ^(NSArray <CKRecord *> * __nullable savedRecords, NSArray <CKRecordID *> * __nullable deletedRecordIDs,
                                               NSError * __nullable operationError) {
        if (operationError) {
            
            if (operationError.code == CKErrorPartialFailure) {
                NSLog(@"There was a problem completing the operation. The following records had problems: %@",
                      [operationError.userInfo objectForKey:CKPartialErrorsByItemIDKey]);
            }
            
            if (handler) {
                
                handler(NO);
            }
            
        } else {
            
            if (handler) {
                
                handler(YES);
            }
        }
    };
    [self.database addOperation:operation];
}

- (void)retrievePostsWithCompletionHandler:(void(^)(NSArray<id<LSRemotePostProtocol>> *posts))handler {
    
    NSPredicate* predicate = [NSPredicate predicateWithValue:YES];
    
    CKQuery* query = [[CKQuery alloc]initWithRecordType:@"Post" predicate:predicate];
    CKQueryOperation* queryOperation = [[CKQueryOperation alloc]initWithQuery:query];
    
    __block NSMutableArray <id<LSRemotePostProtocol>> *records = [NSMutableArray array];
    queryOperation.recordFetchedBlock = ^(CKRecord *record) {
        
        if ([record conformsToProtocol:@protocol(LSRemotePostProtocol)]) {
            
            [records addObject:(id<LSRemotePostProtocol>)record];
        }
    };
    
    queryOperation.queryCompletionBlock = ^(CKQueryCursor * __nullable cursor, NSError * __nullable operationError) {
        
        if (handler) {
            
            handler(records);
        }
    };
    [self.database addOperation:queryOperation];
}


@end
