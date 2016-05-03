//
//  AllJobsModel.h
//  UnivisionBuilds
//
//  Created by Ayman on 11/17/15.
//  Copyright © 2015 Univision. All rights reserved.
//

#import "JSONModel.h"
#import "ASJobModel.h"

@interface ASJobsListModel : JSONModel

@property(nonatomic, strong)NSArray<ASJobModel>* jobs;

@end
