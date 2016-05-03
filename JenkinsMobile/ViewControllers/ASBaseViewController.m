//
//  ASBaseViewController.m
//  JenkinsMoile
//
//  Created by Ayman on 3/2/16.
//  Copyright © 2016 Aspire. All rights reserved.
//

#import "ASBaseViewController.h"

@interface ASBaseViewController ()

@end

@implementation ASBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

#pragma mark - private

- (void)constraintViewToFill:(UIView *)view{
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    
    NSLayoutConstraint *width =[NSLayoutConstraint
                                constraintWithItem:view
                                attribute:NSLayoutAttributeWidth
                                relatedBy:0
                                toItem:view.superview
                                attribute:NSLayoutAttributeWidth
                                multiplier:1.0
                                constant:0];
    NSLayoutConstraint *height =[NSLayoutConstraint
                                 constraintWithItem:view
                                 attribute:NSLayoutAttributeHeight
                                 relatedBy:0
                                 toItem:view.superview
                                 attribute:NSLayoutAttributeHeight
                                 multiplier:1.0
                                 constant:0];
    NSLayoutConstraint *top = [NSLayoutConstraint
                               constraintWithItem:view
                               attribute:NSLayoutAttributeTop
                               relatedBy:NSLayoutRelationEqual
                               toItem:view.superview
                               attribute:NSLayoutAttributeTop
                               multiplier:1.0f
                               constant:0];
    NSLayoutConstraint *leading = [NSLayoutConstraint
                                   constraintWithItem:view
                                   attribute:NSLayoutAttributeLeading
                                   relatedBy:NSLayoutRelationEqual
                                   toItem:view.superview
                                   attribute:NSLayoutAttributeLeading
                                   multiplier:1.0f
                                   constant:0.f];
    [view.superview addConstraint:width];
    [view.superview addConstraint:height];
    [view.superview addConstraint:top];
    [view.superview addConstraint:leading];
}

-(NSLayoutConstraint*)constraintWithIdentifier:(NSString*)identifier andView:(UIView*)view{
    NSArray *constraints = [view constraints];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"identifier = %@", identifier];
    NSArray *filteredArray = [constraints filteredArrayUsingPredicate:predicate];
    if(filteredArray.count > 0){
        NSLayoutConstraint *constraint =  [filteredArray objectAtIndex:0];
        return constraint;
    }
    return nil;
}


-(void)showErrorMessage{
    UIAlertController* alert;
    alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                message:@"An error ocured"
                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showErrorMessage:(NSString*)message{
    UIAlertController* alert;
    alert = [UIAlertController alertControllerWithTitle:@"Error"
                                                message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)showInfoMessage:(NSString*)message{
    UIAlertController* alert;
    alert = [UIAlertController alertControllerWithTitle:nil
                                                message:message
                                         preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}


@end
