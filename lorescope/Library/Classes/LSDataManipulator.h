//
//  LSDataManipulator.h
//  lorescope
//
//  Created by Paul Kuznetsov on 22/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LSDataManipulatorProtocol.h"
#import "Post.h"

@interface LSDataManipulator : NSObject <LSDataManipulatorProtocol>

+ (LSDataManipulator *)sharedManipulator;

- (void)savePostToDB:(Post *)post;
- (Post *)postForID:(NSInteger *)index;
- (NSInteger *)postsCount;

@end
