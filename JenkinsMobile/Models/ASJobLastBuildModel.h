//
//  ASJobLastBuildModel.h
//  IJenkins
//
//  Created by Ayman on 3/6/16.
//  Copyright © 2016 Aspire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

@interface ASJobLastBuildModel : JSONModel

@property (nonatomic, assign  ) long duration;
@property (nonatomic, assign  ) long number;
@property (nonatomic, strong  ) NSString<Optional>  * result;
@property (nonatomic, assign  ) long timestamp;
@property (nonatomic, assign  ) BOOL building;

-(NSString*)timestampAsDate;

@end
