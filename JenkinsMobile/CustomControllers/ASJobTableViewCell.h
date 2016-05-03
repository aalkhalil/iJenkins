//
//  ASJobTableViewCell.h
//  IJenkins
//
//  Created by Ayman on 3/3/16.
//  Copyright © 2016 Aspire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASJobTableViewCell : UITableViewCell

@property(nonatomic, assign) IBOutlet UIImageView *jobStatusImage;
@property(nonatomic, assign) IBOutlet UILabel *jobNameLabel;
@property(nonatomic, assign) IBOutlet UILabel *lastBuildNumberLabel;
@property(nonatomic, assign) IBOutlet UILabel *lastBuildTimeLabel;
@property(nonatomic, assign) IBOutlet UIImageView *healthImage;

@end
