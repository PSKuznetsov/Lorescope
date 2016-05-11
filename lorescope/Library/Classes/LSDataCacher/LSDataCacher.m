//
//  LSDataCacher.m
//  lorescope
//
//  Created by Paul Kuznetsov on 11/05/16.
//  Copyright © 2016 Paul Kuznetsov. All rights reserved.
//

#import "LSDataCacher.h"
#import "LSLocalPostProtocol.h"
#import "LSLocalPost.h"
#import <Realm/Realm.h>

typedef NS_ENUM(NSUInteger, LSRealmType) {
    LSRealmTypeSave,
    LSRealmTypeDelete,
};

@implementation LSDataCacher

#pragma mark - LSDataCacherProtocol

- (void)shouldCacheObjectMarkedForDelete:(id)object {
    
    RLMRealmConfiguration* configuration = [self realmConfigurationForKey:LSRealmTypeDelete];
    RLMRealm* realm = [RLMRealm realmWithConfiguration:configuration error:nil];
    
    if ([object conformsToProtocol:@protocol(LSLocalPostProtocol)]) {
        
        [LSLocalPost createInRealm:realm withValue:object];
    }
}

- (void)shouldCacheObjectMarkedForSave:(id)object {
    
    RLMRealmConfiguration* configuration = [self realmConfigurationForKey:LSRealmTypeSave];
    RLMRealm* realm = [RLMRealm realmWithConfiguration:configuration error:nil];
    
    if ([object conformsToProtocol:@protocol(LSLocalPostProtocol)]) {
        
        [LSLocalPost createInRealm:realm withValue:object];
    }
}

- (id)objectsForDelete {
    
    RLMRealmConfiguration* configuration = [self realmConfigurationForKey:LSRealmTypeDelete];
    RLMRealm* realm = [RLMRealm realmWithConfiguration:configuration error:nil];
    
    RLMResults* allObjects = [LSLocalPost allObjectsInRealm:realm];
    return allObjects;
}

- (id)objectsForSave {
    
    RLMRealmConfiguration* configuration = [self realmConfigurationForKey:LSRealmTypeSave];
    RLMRealm* realm = [RLMRealm realmWithConfiguration:configuration error:nil];
    
    RLMResults* allObjects = [LSLocalPost allObjectsInRealm:realm];
    return allObjects;
}

#pragma mark - Configurator

- (RLMRealmConfiguration *)realmConfigurationForKey:(LSRealmType)type {
    
    NSDictionary* typeStates = @{ @(LSRealmTypeSave)   : @"cache_save",
                                  @(LSRealmTypeDelete) : @"cache_delete", };
    
    RLMRealmConfiguration *config = [RLMRealmConfiguration defaultConfiguration];
    
    config.path = [[[config.path stringByDeletingLastPathComponent]
                    stringByAppendingPathComponent:[typeStates objectForKey:@(type)]]
                   stringByAppendingPathExtension:@"realm"];
    
    return config;
}

@end
