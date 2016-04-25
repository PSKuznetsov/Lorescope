//
//  LSDataManipulator.m
//  lorescope
//
//  Created by Paul Kuznetsov on 22/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "LSDataManipulator.h"
#import <Realm/Realm.h>

@interface LSDataManipulator ()

@end

@implementation LSDataManipulator

+ (LSDataManipulator *)sharedManipulator {
    
    static dispatch_once_t onceToken;
    static LSDataManipulator* manipulator;
    dispatch_once(&onceToken, ^{
        manipulator = [[LSDataManipulator alloc] init];
    });
    
    return manipulator;
}

- (void)savePostToDB:(Post *)post {
    
    RLMRealm* realm = [RLMRealm defaultRealm];
    
    [realm beginWriteTransaction];
    [realm addObject:post];
    [realm commitWriteTransaction];

    
}
- (Post *)postForID:(NSInteger *)index {
    
}
- (NSInteger *)postsCount {
    
}
@end
