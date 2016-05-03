//
//  UserManager.m
//  UnivisionBuilds
//
//  Created by Ayman on 11/8/15.
//  Copyright © 2015 Univision. All rights reserved.
//

#import "ASUserManager.h"

@implementation ASUserManager

#pragma mark Singleton Methods

+ (id)sharedManager {
    static ASUserManager *sharedUserManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedUserManager = [[self alloc] init];
    });
    return sharedUserManager;
}

- (id)init {
    if (self = [super init]) {
        _username = @"";
        _password = @"";
        _jenkinsUrl = @"";
    }
    return self;
}

- (void)dealloc {
    // Should never be called, but just here for clarity really.
}



@end
