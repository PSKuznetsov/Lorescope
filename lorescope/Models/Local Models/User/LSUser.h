//
//  LSUser.h
//  lorescope
//
//  Created by Paul Kuznetsov on 25/03/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSUserProtocol;

@interface LSUser : NSObject <LSUserProtocol>

@property (nonatomic, readonly) NSString* userID;
@property (nonatomic, readonly) NSString* firstname;
@property (nonatomic, readonly) NSString* lastname;

- (void)saveUserID:(NSString*)uuid;
//- (void)saveUser:(NSString*)firstname and:(NSString*)lastname;

@end
