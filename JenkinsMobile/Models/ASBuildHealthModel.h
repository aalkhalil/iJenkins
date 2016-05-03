//
//  ASBuildHealthModel.h
//  IJenkins
//
//  Created by Ayman on 3/6/16.
//  Copyright © 2016 Aspire. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JSONModel.h"

static NSString *HEALTH_OVER_80 = @"icon-health-80plus";
static NSString *HEALTH_61_TO_80 = @"icon-health-60to79";
static NSString *HEALTH_41_TO_60 = @"icon-health-40to59";
static NSString *HEALTH_21_TO_40 = @"icon-health-20to39";
static NSString *HEALTH_0_TO_20 = @"icon-health-00to19";

@protocol ASBuildHealthModel @end

@interface ASBuildHealthModel : JSONModel

@property (nonatomic, strong  ) NSString * iconClassName;

-(UIImage *)heathImage;
+(UIImage *)defaultHeathImage;

@end
