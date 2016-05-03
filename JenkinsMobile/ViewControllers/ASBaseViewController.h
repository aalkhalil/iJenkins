//
//  ASBaseViewController.h
//  JenkinsMoile
//
//  Created by Ayman on 3/2/16.
//  Copyright © 2016 Aspire. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ASBaseViewController : UIViewController

- (void)constraintViewToFill:(UIView *)view;
-(NSLayoutConstraint*)constraintWithIdentifier:(NSString*)identifier andView:(UIView*)view;
-(void)showErrorMessage;
-(void)showErrorMessage:(NSString*)message;
-(void)showInfoMessage:(NSString*)message;
@end
