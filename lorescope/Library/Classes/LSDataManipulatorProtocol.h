//
//  LSDataManipulatorProtocol.h
//  lorescope
//
//  Created by Paul Kuznetsov on 22/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Post.h"

@protocol LSDataManipulatorProtocol <NSObject>
@required

- (void)savePostToDB:(Post *)post;
- (Post *)postForID:(NSInteger *)index;
- (NSInteger *)postsCount;

@end
