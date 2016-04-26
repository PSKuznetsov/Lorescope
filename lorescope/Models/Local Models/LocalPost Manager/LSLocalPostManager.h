//
//  LSLocalPostManager.h
//  lorescope
//
//  Created by Paul Kuznetsov on 26/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSLocalPostManagerProtocol.h"

@interface LSLocalPostManager : NSObject <LSLocalPostManagerProtocol>

- (void)saveLocalPostToDB:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success, NSError* error))handler;
- (void)postWithIndexInDB:(NSUInteger)index completionHandler:(void(^)(id<LSLocalPostProtocol> post, NSError* error))handler;
- (void)deleteLocalPostFromDB:(id<LSLocalPostProtocol>)post competionHandler:(void(^)(BOOL success, NSError* error))handler;
- (void)updateLocalPostInDB:(id<LSLocalPostProtocol>)post completionHandler:(void(^)(BOOL success, NSError* error))handler;

@end
