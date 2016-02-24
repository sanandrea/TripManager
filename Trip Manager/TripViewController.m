//
//  TripViewController.m
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "TripViewController.h"
#import "TripDetailViewController.h"
#import "UIImage+FontAwesome.h"
#import "NSString+FontAwesome.h"
#import "APConstants.h"
#import "Trip.h"
#import "Customer.h"

@interface TripViewController ()
@property (strong, nonatomic) NSArray* trips;
@property (strong, nonatomic) Trip *selectedTrip;
@end

@implementation TripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Trips";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self customizeToolbar];
    
    if (self.userId == nil) {
        //means that we arrived here from appdelegate
        //show trips for the loggedin customer
        CustomerRepository *crepo = (CustomerRepository*)[[APConstants sharedInstance] getCustomerRepository];

        [crepo findCurrentUserWithSuccess:^(LBUser *user){
            [crepo invokeStaticMethod:@"trip-list" parameters:@{@"id" : crepo.currentUserId} success:^(id value){
                  self.trips = (NSArray*) value;
                  [self.tableView reloadData];
            }failure:CALLBACK_FAILURE_BLOCK];
        }failure:CALLBACK_FAILURE_BLOCK];
    }
    
}

-(void) viewWillAppear:(BOOL)animated{
    self.selectedTrip = nil;
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.trips count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"tripCell"
                                                            forIndexPath:indexPath];
    
    
    return cell;
}



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([[segue identifier] isEqualToString:@"showTripInfo"]) {
        UINavigationController *next = (UINavigationController*)[segue destinationViewController];
        TripDetailViewController *tdv = (TripDetailViewController*)[next topViewController];
        tdv.isEditMode = NO;
        if (self.selectedTrip != nil) {
            tdv.isEditMode = YES;
            tdv.trip = self.selectedTrip;
        }
    }
    
}


#pragma mark - UI customization

- (void)customizeToolbar {
    [self.logout setTitleTextAttributes:@{
                                          NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:24.0],
                                          NSForegroundColorAttributeName: self.view.tintColor
                                          } forState:UIControlStateNormal];
    [self.logout setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-sign-out"]];
    [self.addEntry setTitleTextAttributes:@{
                                               NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:24.0],
                                               NSForegroundColorAttributeName: self.view.tintColor
                                               } forState:UIControlStateNormal];
    [self.addEntry setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-plus"]];
    [self.planner setTitleTextAttributes:@{
                                           NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:24.0],
                                           NSForegroundColorAttributeName: self.view.tintColor
                                           } forState:UIControlStateNormal];
    [self.planner setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-calendar"]];
}

#pragma mark - IBActions
- (IBAction)logoutAction:(id)sender {
    
}

- (IBAction)addAction:(id)sender {
    [self performSegueWithIdentifier:@"showTripInfo" sender:self];
}

- (IBAction)plannerAction:(id)sender {
}
@end
