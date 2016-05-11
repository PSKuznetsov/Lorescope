//
//  LSDataCacherProtocol.h
//  lorescope
//
//  Created by Paul Kuznetsov on 11/05/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LSDataCacherProtocol <NSObject>

- (void)shouldCacheObjectMarkedForDelete:(id)object;
- (void)shouldCacheObjectMarkedForSave:(id)object;

- (id)objectsForDelete;
- (id)objectsForSave;

@end
