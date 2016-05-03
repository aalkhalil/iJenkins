//
//  ASLoginViewController.m
//  JenkinsMobile
//
//  Created by Ayman on 3/2/16.
//  Copyright © 2016 Aspire. All rights reserved.
//

#import "ASLoginViewController.h"
#import "ASUserManager.h"
#import "ASKeychainWrapper.h"
#import "JSONHTTPClient.h"

NSString* const ASLogin_constraintSettingsViewTop    = @"constraintSettingsViewTop";
const CGFloat ASLogin_constraintSettingsViewTopValue = -500.0f;
const CGFloat ASLogin_btnOverlayAlpghValue = 0.5f;

@interface ASLoginViewController ()

@property(nonatomic,assign)IBOutlet UIView* viewSettings;
@property(nonatomic,assign)IBOutlet UIButton* btnOverlay;
@property(nonatomic,assign)IBOutlet UIButton* btnSettings;
@property(nonatomic,assign)IBOutlet UITextField* txtUsername;
@property(nonatomic,assign)IBOutlet UITextField* txtPassword;
@property(nonatomic,assign)IBOutlet UITextField* txtUrl;
@property(nonatomic,assign)IBOutlet UISegmentedControl* segmentHttp;
@property(nonatomic,assign)IBOutlet UIActivityIndicatorView* waiting;
@property(nonatomic,strong) ASUserManager* userManager;
@end

@implementation ASLoginViewController

#pragma mark - view controller

- (void)viewDidLoad {
    
    
    
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.userManager =  [self getCurrentUser];
    [self hideSettingsView:NO];
    
    self.viewSettings.layer.borderColor = [[ASColor themeColor] CGColor];
    self.viewSettings.layer.borderWidth = 1;
}

-(void)viewDidAppear:(BOOL)animated{

    if (self.userManager != nil) {
        self.txtUsername.text = self.userManager.username;
        self.txtPassword.text = self.userManager.password;
        
        if ([self.userManager.jenkinsUrl hasPrefix:@"https"]) {
            self.segmentHttp.selectedSegmentIndex = 1;
            self.txtUrl.text = [self.userManager.jenkinsUrl  stringByReplacingOccurrencesOfString:@"https://" withString:@""];
        }
        else{
            self.txtUrl.text = [self.userManager.jenkinsUrl  stringByReplacingOccurrencesOfString:@"http://" withString:@""];
        }
    }
    else{
        self.userManager = [ASUserManager sharedManager];
    }
    
    [self.txtUsername becomeFirstResponder];
    [self animateSettingsButton];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - actions

-(IBAction)btnSettings:(id)sender{
    [self showSettingsView];
}

-(IBAction)btnOverlayDidTapped:(id)sender{
    
    [self hideSettingsView:YES];
}

-(IBAction)btnLogin:(id)sender{
    
    if ([self.txtUrl.text isEqualToString:@""]) {
        [self showSettingsView];
        return;
    }
    
    self.waiting.hidden = NO;
    self.view.userInteractionEnabled = NO;
    NSString* url = self.userManager.jenkinsUrl;
    url = [url stringByAppendingString: @"/api/json?tree=jobs[name]"];
    NSString* strUser = [NSString stringWithFormat:@"%@:%@", self.txtUsername.text, self.txtPassword.text];
    NSData *plainData = [strUser dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [NSString stringWithFormat:@"Basic %@",[plainData base64EncodedStringWithOptions:0]];
    NSMutableDictionary* headers = [JSONHTTPClient requestHeaders];
    [headers setObject:base64String forKey:@"Authorization"];
    
    [JSONHTTPClient getJSONFromURLWithString:url completion:^(id json, JSONModelError *err) {
        
        self.waiting.hidden = YES;
        self.view.userInteractionEnabled = YES;
        if (err == nil) {
            
            ASUserManager *user = [ASUserManager sharedManager];
            user.username = self.txtUsername.text;
            user.password = self.txtPassword.text;
            user.jenkinsUrl = self.userManager.jenkinsUrl;
            
            [self setCurrentUser:self.userManager];
            [self performSegueWithIdentifier:@"segueHome" sender:nil];
        }
        else{
            UIAlertController* alert;
            alert = [UIAlertController alertControllerWithTitle:@"whoops"
                                                        message:@"It seems you entered invalid username or password"
                                                 preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                                  handler:^(UIAlertAction * action) {}];
            
            [alert addAction:defaultAction];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    NSString* jenkinsUrl = @"http://";
    if (self.segmentHttp.selectedSegmentIndex == 1) {
        jenkinsUrl = @"https://";
    }
    self.userManager.jenkinsUrl = [jenkinsUrl stringByAppendingString:self.txtUrl.text];
}

#pragma mark - private

-(void) hideSettingsView:(BOOL)animated{
    
    self.btnOverlay.alpha = 0;
    self.btnOverlay.hidden = NO;
    
    [UIView animateWithDuration:0.3 animations:^{
        self.btnOverlay.alpha = 0;
    } completion:^(BOOL finished) {
        self.btnOverlay.hidden = YES;
    }];
    
    NSLayoutConstraint* constraintSettingsViewTop = [self constraintWithIdentifier:ASLogin_constraintSettingsViewTop andView:self.view];
    constraintSettingsViewTop.constant = ASLogin_constraintSettingsViewTopValue;
    [self.view setNeedsUpdateConstraints];
    self.viewSettings.alpha = 0.2f;
    if (animated) {
        [UIView animateWithDuration:0.3 animations:^{
            [self.view layoutIfNeeded];
        }];
    }
    else{
        [self.view layoutIfNeeded];
    }
    [self.txtUrl resignFirstResponder];
}

-(void)showSettingsView{
    if (self.btnOverlay.alpha == ASLogin_btnOverlayAlpghValue) {
        [self hideSettingsView:YES];
        return;
    }
    
    [self.view bringSubviewToFront:self.btnOverlay];
    [self.view bringSubviewToFront:self.viewSettings];
    
    self.btnOverlay.alpha = 0;
    self.btnOverlay.hidden = NO;
    self.viewSettings.alpha = 1.0f;
    [UIView animateWithDuration:0.3 animations:^{
        self.btnOverlay.alpha = ASLogin_btnOverlayAlpghValue;
    } completion:^(BOOL completed){
        [self.txtUrl becomeFirstResponder];
    }];
    
    NSLayoutConstraint* constraintSettingsViewTop = [self constraintWithIdentifier:ASLogin_constraintSettingsViewTop andView:self.view];
    constraintSettingsViewTop.constant = 100;
    
    [self.view setNeedsUpdateConstraints];
    
    [UIView animateWithDuration:0.3 animations:^{
        [self.view layoutIfNeeded];
    }];
}

-(ASUserManager*)getCurrentUser{
    
    ASKeychainWrapper* keychainWrapper = [[ASKeychainWrapper alloc] init];
    NSString* json = [keychainWrapper myObjectForKey:@"acct"];
    ASUserManager* currentUser = [[ASUserManager alloc] initWithString:json error:nil];
    return currentUser;
}

-(void)setCurrentUser: (ASUserManager*)user{
    
    ASKeychainWrapper* keychainWrapper = [[ASKeychainWrapper alloc] init];
    
    if (user) {
        [keychainWrapper mySetObject:[user toJSONString] forKey:@"acct"];
        [keychainWrapper mySetObject:@"This is username" forKey:@"desc"];
    }
    else{
        [keychainWrapper resetKeychainItem];
    }
}

-(void)animateSettingsButton{
    
    CABasicAnimation* rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 /* full rotation*/ * 1 * 0.3 ];
    rotationAnimation.duration = 0.3;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = 1;
    
    for (int i = 0; i<3; i++) {
        double delayInSeconds = i + 1;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.btnSettings.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
        });
    }
}

@end
