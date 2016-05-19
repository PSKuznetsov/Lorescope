//
//  LSImageManager.m
//  lorescope
//
//  Created by Paul Kuznetsov on 15/05/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "LSImageManager.h"
#import "LSImageManagerProtocol.h"

@interface LSImageManager ()

@property(nonatomic, strong) NSMutableDictionary* cache;

@end

@implementation LSImageManager

#pragma mark - Root

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.cache = [NSMutableDictionary dictionary];
    }
    return self;
}

#pragma mark - LSImageManagerProtocol

- (UIImage *)imageFromDocumentsDirectoryWithName:(NSString *)imageName {
    
    UIImage *image = [self.cache valueForKey:imageName];
    if (image) {
        return image;
    }
    
    NSArray  *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask , YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *path = [documentsDirectory stringByAppendingPathComponent:imageName];
    
    NSData *pngData      = [[NSData alloc]initWithContentsOfFile:path];
    UIImage *loadedImage = [[UIImage alloc]initWithData:pngData];
    
    //redraw image using device context
    UIGraphicsBeginImageContextWithOptions(loadedImage.size, YES, 0);
    [loadedImage drawAtPoint:CGPointZero];
    loadedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    [self.cache setObject:loadedImage forKey:imageName];
    
    return loadedImage;
}

- (NSString *)storeImageOnDisk:(UIImage *)image {
    
    NSData* imageData = UIImagePNGRepresentation(image);
    NSArray *paths    = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    NSDateFormatter* dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd\'T\'HH-mm-ss"];
    
    NSString* dateString = [dateFormatter stringFromDate:[NSDate date]];
    NSString* imageNameComponent  = [NSString stringWithFormat:@"cached-%@%u.png", dateString, arc4random() % 2014 + 1];
    
    NSString *imagePath =[documentsDirectory stringByAppendingPathComponent: imageNameComponent];
    
    [imageData writeToFile:imagePath atomically:YES];
    
    return imageNameComponent;
}

@end
