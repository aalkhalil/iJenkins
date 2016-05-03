//
//  RSKeychainWrapper.h
//  rSpotSocialMobile
//
//  Created by Ayman Alkhalil on 7/13/14.
//  Copyright (c) 2014 rSpotSocial. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ASKeychainWrapper : NSObject{
    NSMutableDictionary        *keychainData;
    NSMutableDictionary        *genericPasswordQuery;
}

@property (nonatomic, strong) NSMutableDictionary *keychainData;
@property (nonatomic, strong) NSMutableDictionary *genericPasswordQuery;

- (void)mySetObject:(id)inObject forKey:(id)key;
- (id)myObjectForKey:(id)key;
- (void)resetKeychainItem;

@end
