//
//  UserManager.h
//  UnivisionBuilds
//
//  Created by Ayman on 11/8/15.
//  Copyright © 2015 Univision. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ASUserManager : JSONModel

@property (nonatomic, retain) NSString *username;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *jenkinsUrl;


+ (id)sharedManager;

@end
