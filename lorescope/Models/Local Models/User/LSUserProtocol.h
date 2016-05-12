//
//  LSUserProtocol.h
//  lorescope
//
//  Created by Paul Kuznetsov on 12/05/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSUserProtocol <NSObject>

@property (nonatomic, readonly) NSString* userID;
@property (nonatomic, readonly) NSString* firstname;
@property (nonatomic, readonly) NSString* lastname;

- (void)saveUserID:(NSString*)uuid;

@end
