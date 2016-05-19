//
//  LSImageManagerProtocol.h
//  lorescope
//
//  Created by Paul Kuznetsov on 15/05/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LSImageManagerProtocol <NSObject>

- (UIImage *)imageFromDocumentsDirectoryWithName:(NSString *)imageName;
- (NSString *)storeImageOnDisk:(UIImage *)image;

@end