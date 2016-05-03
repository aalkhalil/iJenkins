//
//  jobModel.h
//  UnivisionBuilds
//
//  Created by Ayman on 11/16/15.
//  Copyright © 2015 Univision. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import "JSONModel.h"
#import "ASJobLastBuildModel.h"
#import "ASBuildHealthModel.h"

@protocol ASJobModel @end

@interface ASJobModel : JSONModel

@property (nonatomic, strong) NSString            * name;
@property (nonatomic, strong) NSString            * color;
@property (nonatomic, strong) NSString            * url;
@property (nonatomic, strong) ASJobLastBuildModel<Optional> * lastBuild;
@property (nonatomic, strong) NSArray<ASBuildHealthModel>* healthReport;
@property (nonatomic, assign) BOOL inQueue;
@end
