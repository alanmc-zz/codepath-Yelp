//
//  MainViewController.m
//  Yelp
//
//  Created by Timothy Lee on 3/21/14.
//  Copyright (c) 2014 codepath. All rights reserved.
//

#import "MainViewController.h"
#import "YelpClient.h"
#import "YelpResultTableViewCell.h"
#import "Business.h"

NSString * const kYelpConsumerKey = @"jo30sfYRQFioBI4EEB0Z_w";
NSString * const kYelpConsumerSecret = @"u1xraNnCEo7BX6UFgmjP0JU_BFA";
NSString * const kYelpToken = @"QQtyEL80E36IISBZlmPjEUPXv4Lgpl29";
NSString * const kYelpTokenSecret = @"rcqpqfPAj4qxFE6FpsO9fHvJ5vo";

@interface MainViewController ()

@property (strong, nonatomic) YelpClient *client;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, atomic) NSArray *searchResults;
@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.client = [[YelpClient alloc] initWithConsumerKey:kYelpConsumerKey
                                               consumerSecret:kYelpConsumerSecret
                                                  accessToken:kYelpToken
                                                 accessSecret:kYelpTokenSecret];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Yelp";

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = UITableViewAutomaticDimension;
    [self.tableView registerNib:[UINib nibWithNibName:@"YelpResultTableViewCell" bundle:nil]
                                 forCellReuseIdentifier:@"YelpResultTableViewCell"];

    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc] initWithTitle:@"Filter"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self
                                                                  action:@selector(onFilter)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    [self.client searchWithTerm:@"Thai"
                        success:^(AFHTTPRequestOperation *operation, id response) {
        self.searchResults = [Business businessesWithDictionaries:response[@"businesses"]];
        [self.tableView reloadData];
    }
                        failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"error: %@", [error description]);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.searchResults.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    YelpResultTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"YelpResultTableViewCell"];

    [cell setBusiness:self.searchResults[indexPath.row]];
    return cell;
}

- (void)onFilter {
    NSLog(@"Filter");
}

@end
