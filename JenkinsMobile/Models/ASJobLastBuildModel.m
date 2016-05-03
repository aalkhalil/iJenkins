//
//  ASJobLastBuildModel.m
//  IJenkins
//
//  Created by Ayman on 3/6/16.
//  Copyright © 2016 Aspire. All rights reserved.
//

#import "ASJobLastBuildModel.h"

@implementation ASJobLastBuildModel


-(NSString*)timestampAsDate{
    
    NSTimeInterval _interval=_timestamp/1000;
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:_interval];
    NSDateFormatter *_formatter=[[NSDateFormatter alloc]init];
    [_formatter setDateStyle:NSDateFormatterLongStyle];
    [_formatter setTimeStyle:NSDateFormatterShortStyle];
    return [_formatter stringFromDate:date];
}

@end
