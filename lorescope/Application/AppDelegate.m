    //
    //  AppDelegate.m
    //  lorescope
    //
    //  Created by Paul Kuznetsov on 16/10/15.
    //  Copyright © 2015 Paul Kuznetsov. All rights reserved.
    //

#import "AppDelegate.h"
#import "MainViewController.h"

#import "LSlocalPostManagerProtocol.h"
#import "LSDataManipulatorProtocol.h"

#import "LSDataManipulator.h"
#import "LSLocalPostManager.h"

#import "LSRemotePostManagerProtocol.h"
#import "LSRemotePostManager.h"

#import "LSDataSynchronizerProtocol.h"
#import "LSDataSynchronizer.h"

#import "LSControllerManipulatorDelegate.h"

#import "LSRemotePost.h"

#import <CloudKit/CloudKit.h>
#import <OnboardingViewController.h>
#import <OnboardingContentViewController.h>
#import <Realm/Realm.h>

static NSString* const kLastTokenUsed = @"kLastTokenUsedID";

@interface AppDelegate ()
@property (nonatomic, strong) id <LSLocalPostManagerProtocol> localManager;
@property (nonatomic, strong) id <LSRemotePostManagerProtocol> remoteManager;
@property (nonatomic, strong) id <LSDataManipulatorProtocol> manipulator;
@property (nonatomic, strong) id <LSControllerManipulatorDelegate> manipulatorDelegate;
@property (nonatomic, strong) id <LSDataSynchronizerProtocol> dataSynchronizer;
@property (nonatomic, strong) CKServerChangeToken* previousChangeToken;
@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [self configureDependencies];
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"ApplicationLaunchedOnce"]) {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ApplicationLaunchedOnce"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        OnboardingContentViewController *firstPage = [OnboardingContentViewController contentWithTitle:@"Welcome to Lorescope" body:@"To the new way store your memmories..." image:[UIImage imageNamed:@"AppIcon"] buttonText:nil action:^{
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }];
        
        OnboardingContentViewController *secondPage = [OnboardingContentViewController contentWithTitle:@"Store your memmoriese photos with thougths" body:nil image:[UIImage imageNamed:@"AppIcon"] buttonText:nil action:^{
                // do something here when users press the button, like ask for location services permissions, register for push notifications, connect to social media, or finish the onboarding process
        }];
        
        OnboardingViewController *onboardingVC = [OnboardingViewController onboardWithBackgroundImage:nil contents:@[firstPage, secondPage]];
    }
    
    UIStoryboard* storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    MainViewController* mainViewController = [storyboard instantiateViewControllerWithIdentifier:@"MainViewController"];
    UINavigationController* navController  = [[UINavigationController alloc] initWithRootViewController:mainViewController];
    self.manipulatorDelegate = mainViewController;
    self.window.rootViewController = navController;
    
    [self synchronizeData];
    
    return YES;
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [self fetchNotificationChanges];
}

#pragma mark - Remote Notifications

- (void)application:(UIApplication *)application didRegisterUserNotificationSettings:(UIUserNotificationSettings *)notificationSettings {
    //register to receive notifications
    [application registerForRemoteNotifications];
}

- (void)subscribeForCloudKitChanges {
    
    __weak typeof(self) weakSelf = self;
    
    CKDatabase *privateDatabase = [[CKContainer defaultContainer] privateCloudDatabase];
    
        // Then, we check if there is an iCloud account available so we can have write permission
    [[CKContainer defaultContainer] accountStatusWithCompletionHandler:^(CKAccountStatus accountStatus, NSError * _Nullable error) {
        
        if (accountStatus == CKAccountStatusAvailable) {
            
            [privateDatabase fetchAllSubscriptionsWithCompletionHandler:^(NSArray<CKSubscription *> * _Nullable subscriptions, NSError * _Nullable error) {
                if (!error) {
                    if (subscriptions.count == 0) {
                            // Then, subscribe to future updates
                        
                        NSPredicate *predicate       = [NSPredicate predicateWithFormat:@"TRUEPREDICATE"];
                        
                        CKSubscription *subscription = [[CKSubscription alloc] initWithRecordType:@"Post"
                                                                                        predicate:predicate
                                                                                          options:CKSubscriptionOptionsFiresOnRecordCreation |
                                                        CKSubscriptionOptionsFiresOnRecordUpdate |
                                                        CKSubscriptionOptionsFiresOnRecordDeletion];
                        
                        CKNotificationInfo *notificationInfo = [CKNotificationInfo new];
                        notificationInfo.alertLocalizationKey = @"Something happend in Lorescope. Check it now!";
                        notificationInfo.shouldSendContentAvailable = YES;
                        subscription.notificationInfo = notificationInfo;
                        
                        
                        [privateDatabase saveSubscription:subscription
                                        completionHandler:^(CKSubscription * _Nullable subscription, NSError * _Nullable error) {
                                            if (error) {
                                                    // Handle here the error
                                                NSLog(@"%@", error.localizedDescription);
                                            } else {
                                                NSLog(@"Subscribe successfully!");
                                            }
                        }];
                    }
                    else if (subscriptions.count > 1) {
                        for (CKSubscription* subscription in subscriptions) {
                            [privateDatabase deleteSubscriptionWithID:subscription.subscriptionID completionHandler:^(NSString * _Nullable subscriptionID, NSError * _Nullable error) {
                                NSLog(@"Sub deleted: %@", subscriptionID);
                            }];
                        }
                        [weakSelf subscribeForCloudKitChanges];
                    }
                }
                else {
                    
                    NSLog(@"Error - %@", error.localizedDescription);
                }
            }];
            
        }
    }];
}


- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(nonnull void (^)(UIBackgroundFetchResult))completionHandler {
    
    if(application.applicationState == UIApplicationStateActive || application.applicationState == UIApplicationStateInactive) {
        
        [self fetchNotificationChanges];

        completionHandler(UIBackgroundFetchResultNewData);
        
    }
    else {
        
        completionHandler(UIBackgroundFetchResultNoData);
    }
}

- (void)fetchNotificationChanges {
    
    NSLog(@"Starting with fetchNotificationChanges");
    CKFetchNotificationChangesOperation *operation = [[CKFetchNotificationChangesOperation alloc] initWithPreviousServerChangeToken:self.previousChangeToken];
    
    NSMutableArray *notificationIDsToMarkRead = [NSMutableArray array];
    
    operation.notificationChangedBlock = ^(CKNotification * notification) {
            // Process each notification received
        if (notification.notificationType == CKNotificationTypeQuery) {
            
            CKQueryNotification *queryNotification = (CKQueryNotification *)notification;
            CKQueryNotificationReason reason = queryNotification.queryNotificationReason;
            CKRecordID *recordID = queryNotification.recordID;
            
            NSLog(@"Record has arrived - %@", recordID.recordName);
            
                // Do process here depending on the reason of the change
            if (reason == CKQueryNotificationReasonRecordDeleted) {
                
                NSLog(@"Deleting with fetchNotificationChanges");
                
                __block NSString* recordName = [recordID.recordName copy];
                
                __weak typeof(self) weakSelf = self;
                [self.localManager deleteLocalPostFromDBWithPostID:recordName competionHandler:^(BOOL success, NSError *error) {
                    if (success) {
                        NSLog(@"Reloading data from AppDelegate");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [weakSelf.manipulatorDelegate contorllerShouldPerformReloadData:nil];
                        });
                    }
                }];
                
            } else {
                    // If the record has been created or changed, we fetch the data from CloudKit
                CKDatabase *database = [[CKContainer defaultContainer] privateCloudDatabase];
                [database fetchRecordWithID:recordID completionHandler:^(CKRecord * _Nullable record, NSError * _Nullable error) {
                    
                    if (error) {
                            // Handle the error here
                    }
                    else {
                        LSRemotePost* downloadedPost = [[LSRemotePost alloc]initWithRecord:record];
                        if (reason == CKQueryNotificationReasonRecordUpdated) {
                                // Use the information in the record object to modify your local data
                        }
                        else {
                            
                            NSLog(@"We should save push with fetchNotificationChanges!");
                            __weak typeof(self)weakSelf = self;
                            [self.manipulator shouldSaveRemotePost:downloadedPost completionHandler:^(BOOL success) {
                                if (success) {
                                    dispatch_async(dispatch_get_main_queue(), ^{
                                        [weakSelf.manipulatorDelegate contorllerShouldPerformReloadData:nil];
                                    });
                                }
                            }];
                        }
                    }
                }];
            }
                // Add the notification id to the array of processed notifications to mark them as read
            [notificationIDsToMarkRead addObject:queryNotification.notificationID];
        }
    };
    
    __weak CKFetchNotificationChangesOperation* weakOperation = operation;
    operation.fetchNotificationChangesCompletionBlock = ^(CKServerChangeToken * serverChangeToken, NSError * operationError) {
        if (operationError) {
            // Handle the error here
        } else {
            
            self.previousChangeToken = serverChangeToken;
            // Mark the notifications as read to avoid processing them again
            CKMarkNotificationsReadOperation *markOperation = [[CKMarkNotificationsReadOperation alloc] initWithNotificationIDsToMarkRead:notificationIDsToMarkRead];
            markOperation.markNotificationsReadCompletionBlock = ^(NSArray<CKNotificationID *> * notificationIDsMarkedRead, NSError * operationError) {
                if (operationError) {
                    // Handle the error here
                }
            };
            
            NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
            [operationQueue addOperation:markOperation];
            
            if (weakOperation.moreComing) {
                    //[self fetchNotificationChanges];
            }
        }
    };
    
    [operation start];
}

#pragma mark - Accessors

- (void)setPreviousChangeToken:(CKServerChangeToken *)previousChangeToken {
    
    if (previousChangeToken) {
        [[NSUserDefaults standardUserDefaults] setObject:
             [NSKeyedArchiver archivedDataWithRootObject:previousChangeToken]
                                                  forKey:kLastTokenUsed];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

- (CKServerChangeToken *)previousChangeToken {
    
    NSData* encodedData = [[NSUserDefaults standardUserDefaults]objectForKey:kLastTokenUsed];
    CKServerChangeToken* decodedData = nil;
    if (encodedData) {
        decodedData = [NSKeyedUnarchiver unarchiveObjectWithData:encodedData];

    }
    
    return decodedData;
}

#pragma mark - Initializations

- (void)configureDependencies {
    
    self.localManager = [[LSLocalPostManager alloc]init];;
    self.manipulator  = [[LSDataManipulator alloc]init];
    self.remoteManager = [[LSRemotePostManager alloc]initWithDatabase:[[CKContainer defaultContainer] privateCloudDatabase]];
    self.dataSynchronizer = [[LSDataSynchronizer alloc]initWithDataManipulator:self.manipulator];
}

- (void)synchronizeData {
    
    __weak typeof(self) weakSelf = self;
    [self.dataSynchronizer shouldSynchronizeDataWithCompletionHandler:^(BOOL success, NSError *error) {
        if (success) {
                //push notifications setup
            UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeSound categories:nil];
            [[UIApplication sharedApplication] registerUserNotificationSettings:notificationSettings];
                //registering for notifications
            NSLog(@"Boo! We have DONE IT!");
            [weakSelf subscribeForCloudKitChanges];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.manipulatorDelegate contorllerShouldPerformReloadData:nil];
            });
        }
        else {
            
            NSLog(@"Error with sync data: - %@", error.localizedDescription);
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.manipulatorDelegate contorllerShouldPerformReloadData:nil];
            });
        }
    }];
}

@end
