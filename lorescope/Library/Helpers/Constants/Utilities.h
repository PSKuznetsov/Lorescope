//
//  Utilities.h
//  lorescope
//
//  Created by Paul Kuznetsov on 18/10/15.
//  Copyright © 2015 Paul Kuznetsov. All rights reserved.
//

#import <Foundation/Foundation.h>

@import UIKit;

///////////////
/// Devices ///
///////////////

bool is_iPad() {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad);
}

bool is_iPhone() {
    return (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone);
}

bool is_iPhone_4() {
    return (is_iPhone() && [[UIScreen mainScreen] bounds].size.height == 480.0);
}

bool is_iPhone_5() {
    return (is_iPhone() && [[UIScreen mainScreen] bounds].size.height == 568.0);
}

bool is_iPhone_6() {
    return (is_iPhone() && [[UIScreen mainScreen] bounds].size.height == 667.0);
}

bool is_iPhone_6_Plus() {
    return (is_iPhone() && [[UIScreen mainScreen] bounds].size.height == 736.0);
}
