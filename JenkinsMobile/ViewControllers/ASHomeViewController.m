//
//  ASHomeViewController.m
//  JenkinsMoile
//
//  Created by Ayman on 3/2/16.
//  Copyright © 2016 Aspire. All rights reserved.
//

#import "ASHomeViewController.h"
#import "ASUserManager.h"
#import "JSONHTTPClient.h"
#import "ASJobsListModel.h"
#import "ASJobModel.h"
#import "ASJobTableViewCell.h"
#import "ASBuildHealthModel.h"
#import "ASJobDetailsViewController.h"

NSString* const ASHOME_segueJobDetails = @"segueJobDetails";

@interface ASHomeViewController ()

@property(nonatomic, assign) IBOutlet UITableView *tableView;
@property(nonatomic, strong) UIRefreshControl *refreshControl;
@property(nonatomic, strong) NSMutableArray *jobsList;
@property(nonatomic, strong) NSMutableArray *jobsListFiltered;
@property(nonatomic, strong) ASJobModel *selectedJobModel;

@end

@implementation ASHomeViewController

#pragma mark - view controller

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    [self loadData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(loadData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

-(void)viewDidAppear:(BOOL)animated{
    //[self performSegueWithIdentifier:@"segueLogin" sender:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:ASHOME_segueJobDetails]) {
        ASJobDetailsViewController* jobDetailsViewController = segue.destinationViewController;
        jobDetailsViewController.jobModel = self.selectedJobModel;
    }
}

#pragma mark - table view

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    // Return the number of sections.
    if (_jobsList || _jobsList.count > 0) {
        
        //self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
        
    } else {
        
        // Display a message when the table is empty
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
        
        messageLabel.text = @"No data is currently available. Please pull down to refresh.";
        messageLabel.textColor = [ASColor themeColor];
        messageLabel.numberOfLines = 0;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont fontWithName:@"Palatino-Italic" size:20];
        [messageLabel sizeToFit];
        
        self.tableView.backgroundView = messageLabel;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        
    }
    
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return _jobsListFiltered.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"jenkinsjobCell";
    ASJobTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[ASJobTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }

    ASJobModel *job = [_jobsListFiltered objectAtIndex:indexPath.row];
    cell.jobNameLabel.text = job.name;
    cell.lastBuildNumberLabel.text = [NSString stringWithFormat:@"%ld", job.lastBuild.number];
    cell.lastBuildTimeLabel.text = [NSString stringWithFormat:@"%@", [job.lastBuild timestampAsDate]];
    ASBuildHealthModel *health = job.healthReport.firstObject;
    [cell.jobStatusImage.layer removeAllAnimations];
    cell.jobStatusImage.alpha = 1;

    if (health) {
        cell.healthImage.image = [health heathImage];
    } else{
        cell.healthImage.image = [ASBuildHealthModel defaultHeathImage];
    }
    
    if ([job.color isEqualToString:@"blue"]) {
        cell.jobStatusImage.image = [UIImage imageNamed:@"job-blue"];
    }else if ([job.color isEqualToString:@"red"]){
        cell.jobStatusImage.image = [UIImage imageNamed:@"job-red"];
    }
    else if ([job.color isEqualToString:@"unstable"]){
        cell.jobStatusImage.image = [UIImage imageNamed:@"job-unstable"];
    }
    else{
        cell.jobStatusImage.image = [UIImage imageNamed:@"job-notbuilt"];
    }
    
    if (job.lastBuild.building) {
        [UIView animateWithDuration:0.5  delay:0 options:UIViewAnimationOptionRepeat| UIViewAnimationOptionAutoreverse animations:^{
            cell.jobStatusImage.alpha = 0;

        } completion:nil];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    self.selectedJobModel = [self.jobsListFiltered objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:ASHOME_segueJobDetails sender:nil];
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
}
#pragma mark - UISearchBar Delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    
    if ([searchText isEqualToString:@""]) {
        _jobsListFiltered = [[NSMutableArray alloc] initWithArray: _jobsList];
        [self.tableView reloadData];
        return;
    }
    NSArray *array = [[NSArray alloc] initWithArray:_jobsList];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@", searchText ];
    array  = [array filteredArrayUsingPredicate:predicate];
    _jobsListFiltered = [[NSMutableArray alloc] initWithArray: array];
    [self.tableView reloadData];
}

#pragma mark - private

-(void) loadData{
    _jobsList = [[NSMutableArray alloc] init];
    ASUserManager* userManager = [ASUserManager sharedManager];
    
    NSString *url = [userManager.jenkinsUrl stringByAppendingString: @"/api/json?tree=jobs[name,color,url,inQueue,lastBuild[number,duration,timestamp,result,building],healthReport[iconClassName]]"];
    
    NSString* strUser = [NSString stringWithFormat:@"%@:%@", userManager.username, userManager.password];
    NSData *plainData = [strUser dataUsingEncoding:NSUTF8StringEncoding];
    NSString *base64String = [NSString stringWithFormat:@"Basic %@",[plainData base64EncodedStringWithOptions:0]];
    NSMutableDictionary* headers = [JSONHTTPClient requestHeaders];
    [headers setObject:base64String forKey:@"Authorization"];
    
    [JSONHTTPClient getJSONFromURLWithString:url completion:^(id json, JSONModelError *err) {
        
        if (err) {
            //[self showErrorMessage];
            return;
        }
        
        NSError *error;
        ASJobsListModel* jobsList = [[ASJobsListModel alloc] initWithDictionary:json error:&error];
        
        for (ASJobModel* item in jobsList.jobs) {
            [self.jobsList addObject:item];
        }
        
        _jobsListFiltered = [[NSMutableArray alloc] initWithArray: _jobsList];
        [self.tableView reloadData];
        
        if (self.refreshControl) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"MMM d, h:mm a"];
            NSString *title = [NSString stringWithFormat:@"Last update: %@", [formatter stringFromDate:[NSDate date]]];
            NSDictionary *attrsDictionary = [NSDictionary dictionaryWithObject:[UIColor whiteColor]
                                                                        forKey:NSForegroundColorAttributeName];
            NSAttributedString *attributedTitle = [[NSAttributedString alloc] initWithString:title attributes:attrsDictionary];
            self.refreshControl.attributedTitle = attributedTitle;
            
            [self.refreshControl endRefreshing];
        }
    }];
}

@end
