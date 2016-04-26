//
//  LSLocalPostProtocol.h
//  lorescope
//
//  Created by Paul Kuznetsov on 26/04/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol LSLocalPostProtocol <NSObject>
@property (nonatomic, copy) NSString* photoPath;
@property (nonatomic, copy) NSString* postID;
@property (nonatomic, copy) NSString* content;
@property (nonatomic, strong) NSDate* createdAt;
@property (nonatomic, strong) NSDate* lastModifiedAt;
@end
