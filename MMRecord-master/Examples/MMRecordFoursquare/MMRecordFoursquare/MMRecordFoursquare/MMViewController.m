//
//  MMViewController.m
//  MMRecordFoursquare
//
//  Created by Conrad Stoll on 11/5/13.
//  Copyright (c) 2013 Mutual Mobile. All rights reserved.
//

#import "MMViewController.h"

#import "MMFoursquareSessionManager.h"

#import "Venue.h"
#import "Location.h"

#import "MMVenueViewController.h"
#import "MMDataManager.h"

@interface MMViewController ()
    
@property (nonatomic, copy) NSArray *venues;

@end

@implementation MMViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [[UIRefreshControl alloc] init];
    [self.refreshControl addTarget:self
                            action:@selector(refreshVenues)
                  forControlEvents:UIControlEventValueChanged];
    [self setRefreshControl:self.refreshControl];
    
    NSString *oAuthToken = @"RMRLHPHOTZBIHKAX2G1XMZ33XQYDYKVCAUTM5GCTAA03X04F";
    
    [[MMFoursquareSessionManager sharedClient]
     GET:@"venues/search?ll=30.25,-97.75"
     parameters:@{@"oauth_token": oAuthToken, @"v": @"20131105"}
     success:^(NSURLSessionDataTask *task, id responseObject) {
         NSArray *venues = responseObject;
         
         self.venues = venues;
         
         [self.tableView reloadData];
     } failure:^(NSURLSessionDataTask *task, NSError *error) {
         
     }];
}

- (void)refreshVenues {
    NSManagedObjectContext *context = [[MMDataManager sharedDataManager] managedObjectContext];
    
    NSString *oAuthToken = @"RMRLHPHOTZBIHKAX2G1XMZ33XQYDYKVCAUTM5GCTAA03X04F";
    
    [Venue startBatchedRequestsInExecutionBlock:^{
        [Venue
         startRequestWithURN:@"venues/search?ll=30.25,-97.75"
         data:@{@"oauth_token": oAuthToken, @"v": @"20131105"}
         context:context
         domain:nil
         resultBlock:^(NSArray *records) {
             NSArray *venues = records;
             
             self.venues = venues;
             
             [self.tableView reloadData];
             
             [self.refreshControl endRefreshing];
             
             NSLog(@"0");
         }
         failureBlock:^(NSError *error) {
         }];
        
        [Venue
         startRequestWithURN:@"venues/search?ll=30.25,-97.75"
         data:@{@"oauth_token": oAuthToken, @"v": @"20131105"}
         context:context
         domain:nil
         resultBlock:^(NSArray *records) {
             NSLog(@"1");
         }
         failureBlock:^(NSError *error) {
         }];
        
        [Venue
         startRequestWithURN:@"venues/search?ll=30.25,-97.75"
         data:@{@"oauth_token": oAuthToken, @"v": @"20131105"}
         context:context
         domain:nil
         resultBlock:^(NSArray *records) {
             NSLog(@"2");
         }
         failureBlock:^(NSError *error) {
         }];
        
        [Venue
         startRequestWithURN:@"venues/search?ll=30.25,-97.75"
         data:@{@"oauth_token": oAuthToken, @"v": @"20131105"}
         context:context
         domain:nil
         resultBlock:^(NSArray *records) {
             NSLog(@"3");
         }
         failureBlock:^(NSError *error) {
         }];
        [Venue
         startRequestWithURN:@"venues/search?ll=30.25,-97.75"
         data:@{@"oauth_token": oAuthToken, @"v": @"20131105"}
         context:context
         domain:nil
         resultBlock:^(NSArray *records) {
             NSLog(@"4");
         }
         failureBlock:^(NSError *error) {
         }];
        [Venue
         startRequestWithURN:@"venues/search?ll=30.25,-97.75"
         data:@{@"oauth_token": oAuthToken, @"v": @"20131105"}
         context:context
         domain:nil
         resultBlock:^(NSArray *records) {
             NSLog(@"5");
         }
         failureBlock:^(NSError *error) {
         }];
    } withCompletionBlock:^{
        [self.refreshControl endRefreshing];
        NSLog(@"Done");
    }];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.venues count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CellIdentifier" forIndexPath:indexPath];
    
    Venue *venue = self.venues[indexPath.row];
    
    UILabel *venueNameLabel = [self venueNameLabelInCell:cell];
    venueNameLabel.text = venue.name;
    
    UILabel *addressLabel = [self addressLabelInCell:cell];
    addressLabel.text = venue.location.address;
    
    return cell;
}


#pragma mark - Segue Methods

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    Venue *venue = self.venues[indexPath.row];
    
    MMVenueViewController *venueViewController = segue.destinationViewController;
    venueViewController.venue = venue;
}


#pragma mark - Private Cell Methods

- (UILabel *)venueNameLabelInCell:(UITableViewCell *)cell {
    for (UIView *view in [cell.contentView subviews]) {
        if (view.tag == 10) {
            if ([view isKindOfClass:[UILabel class]]) {
                return (UILabel *)view;
            }
        }
    }
    
    return nil;
}

- (UILabel *)addressLabelInCell:(UITableViewCell *)cell {
    for (UIView *view in [cell.contentView subviews]) {
        if (view.tag == 11) {
            if ([view isKindOfClass:[UILabel class]]) {
                return (UILabel *)view;
            }
        }
    }
    
    return nil;
}

@end
