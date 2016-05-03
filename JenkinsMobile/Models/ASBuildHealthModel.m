//
//  ASBuildHealthModel.m
//  IJenkins
//
//  Created by Ayman on 3/6/16.
//  Copyright © 2016 Aspire. All rights reserved.
//

#import "ASBuildHealthModel.h"

@implementation ASBuildHealthModel

-(UIImage *)heathImage{
    
    if ([_iconClassName isEqualToString:HEALTH_OVER_80]) {
        return [UIImage imageNamed:@"health-80plus"];
    } else if ([_iconClassName isEqualToString:HEALTH_61_TO_80]) {
        return [UIImage imageNamed:@"health-60to79"];
    }
    else if ([_iconClassName isEqualToString:HEALTH_41_TO_60]) {
        return [UIImage imageNamed:@"health-40to59"];
    }
    else if ([_iconClassName isEqualToString:HEALTH_21_TO_40]) {
        return [UIImage imageNamed:@"health-20to39"];
    }
    else if ([_iconClassName isEqualToString:HEALTH_0_TO_20]) {
        return [UIImage imageNamed:@"health-00to19"];
    }
    return [UIImage imageNamed:@"health-80plus"];
}
+(UIImage *)defaultHeathImage{
    return [UIImage imageNamed:@"health-80plus"];
}

@end
