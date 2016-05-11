//
//  MainViewController+Auth.m
//  lorescope
//
//  Created by Paul Kuznetsov on 01/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//
#import <CloudKit/CloudKit.h>
#import <SVProgressHUD.h>
#import <Realm/Realm.h>

#import "LSDataSynchronizer.h"
#import "MainViewController+Auth.h"
#import "LSUser.h"


@implementation MainViewController (Auth)

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [SVProgressHUD show];
    
    CKContainer* container = [CKContainer defaultContainer];
    [container fetchUserRecordIDWithCompletionHandler:^(CKRecordID * _Nullable recordID, NSError * _Nullable error) {
        
        if (error) {
            
            NSLog(@"iCloud error: %@", error.localizedDescription);
            
                //TODO: show popup
            
        } else {
            
            if (![self.user.userID isEqual:recordID.recordName]) {
                
                [self.user saveUserID:recordID.recordName];                
                
                NSLog(@"User iCloud ID(updated): %@", self.user.userID);
                
                //Deleting all previous data from DB
                RLMRealm* realm = [RLMRealm defaultRealm];
                
                [realm beginWriteTransaction];
                [realm deleteAllObjects];
                [realm commitWriteTransaction];
            }

            NSLog(@"User iCloud (saved): %@", self.user.userID);
            
            [SVProgressHUD dismiss];
        }
        
    }];
    
}

@end
