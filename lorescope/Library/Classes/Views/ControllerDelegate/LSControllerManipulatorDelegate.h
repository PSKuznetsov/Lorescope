//
//  LSControllerManipulatorDelegate.h
//  lorescope
//
//  Created by Paul Kuznetsov on 05/05/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol LSControllerManipulatorDelegate <NSObject>

- (void)contorllerShouldPerformReloadData:(UIViewController *)controller;

@end
