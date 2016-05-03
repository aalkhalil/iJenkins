//
//  ASJobDetailsViewController.m
//  IJenkins
//
//  Created by Ayman on 3/8/16.
//  Copyright © 2016 Aspire. All rights reserved.
//

#import "ASJobDetailsViewController.h"
#import "ASBuildHealthModel.h"

@interface ASJobDetailsViewController ()

@property(nonatomic, assign) IBOutlet UILabel *lblJobName;
@property(nonatomic, assign) IBOutlet UIImageView *healthImage;
@property(nonatomic, assign) IBOutlet UITableView *tableView;
@property(nonatomic, strong) UIRefreshControl *refreshControl;
@property(nonatomic, strong) NSMutableArray *buildsList;

@end

@implementation ASJobDetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.lblJobName.text= self.jobModel.name;
    ASBuildHealthModel *health = self.jobModel.healthReport.firstObject;
    
    if (health) {
        self.healthImage.image = [health heathImage];
    } else{
        self.healthImage.image = [ASBuildHealthModel defaultHeathImage];
    }
    
    [self loadData];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    self.refreshControl.backgroundColor = [UIColor purpleColor];
    self.refreshControl.tintColor = [UIColor whiteColor];
    [self.refreshControl addTarget:self
                            action:@selector(loadData)
                  forControlEvents:UIControlEventValueChanged];
    [self.tableView addSubview:self.refreshControl];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadData{
    
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
}

@end
