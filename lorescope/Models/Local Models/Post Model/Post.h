//
//  Post.h
//  lorescope
//
//  Created by Paul Kuznetsov on 05/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Realm/Realm.h>

@interface Post : RLMObject

@property (nonatomic, copy) NSString* comment;
@property (nonatomic, copy) NSString* photoPath;
@property (nonatomic) NSDate* publicationDate;
@property (nonatomic, assign) long long postID;

@end
