//
//  MasterViewController.m
//  Trip Manager
//
//  Created by Andi Palo on 22/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "UserViewController.h"
#import "DetailViewController.h"
#import "NSString+FontAwesome.h"
#import "UserCell.h"
#import "Customer.h"
#import "TripViewController.h"
#import "EditUserViewController.h"
#import "LoginViewController.h"

@interface UserViewController ()

@property (strong, nonatomic) NSMutableArray* users;
@property (nonatomic) BOOL showAllTrips;
@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = NSLocalizedString(@"Users", @"users title");

    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableView.allowsSelectionDuringEditing = YES;
    [self customizeToolbar];
    
}

- (void)viewWillAppear:(BOOL)animated {
    self.showAllTrips = NO;
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    CustomerRepository *crepo = (CustomerRepository*)[[APConstants sharedInstance] getCustomerRepository];
    NSDictionary *filter = @{@"include":@{@"relation":@"roleMapping", @"scope":@{@"include":@"role"}}};
    [crepo findWithFilter:filter success:^(NSArray *customers){
        self.users = [NSMutableArray arrayWithArray:customers];
        [self.tableView reloadData];
    } failure:CALLBACK_FAILURE_BLOCK];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
    UIViewController *next = [segue destinationViewController];
    NSString *userId = [[self.users objectAtIndex:[selectedIndexPath row]] valueForKey:@"id"];
    
    if ([[segue identifier] isEqualToString:@"showTripsOfUser"]) {
        TripViewController *tvc = (TripViewController*) next;
        tvc.userId = userId;
        if (self.showAllTrips) {
            tvc.showAlltrips = YES;
        }
    }else if ([[segue identifier] isEqualToString:@"editUserSegue"]) {
        EditUserViewController *euvc = (EditUserViewController*)next;
        euvc.customer = (Customer*)[self.users objectAtIndex:[selectedIndexPath row]];
    }else if ([[segue identifier] isEqualToString:@"presentLoginView"]){
        LoginViewController *lvc = (LoginViewController*)[segue destinationViewController];
        lvc.isManager = YES;
    }
    [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.users.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UserCell *cell = (UserCell*)[tableView dequeueReusableCellWithIdentifier:@"userCell" forIndexPath:indexPath];
    Customer *customer = [self.users objectAtIndex:[indexPath row]];
    
    cell.usernameLabel.text = customer.username;
    if ([customer[@"roleMapping"] count] > 0) {
        cell.userRoleLabel.hidden = NO;
        cell.userRoleValue.hidden = NO;
        cell.userRoleLabel.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
        cell.userRoleLabel.text = [NSString fontAwesomeIconStringForEnum:FAUsers];
        cell.userRoleValue.text = customer[@"roleMapping"][@"role"][@"name"];
    }else{
        cell.userRoleLabel.hidden = YES;
        cell.userRoleValue.hidden = YES;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.tableView.editing == NO) {
        [self performSegueWithIdentifier:@"showTripsOfUser" sender:self];
    }else{
        [self performSegueWithIdentifier:@"editUserSegue" sender:self];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Customer *toDelete = (Customer*)[self.users objectAtIndex:[indexPath row]];
        [toDelete destroyWithSuccess:^{
            [self.users removeObject:toDelete];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:CALLBACK_FAILURE_BLOCK];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
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
    UserRole role = ((APConstants*)[APConstants sharedInstance]).currentUserRole;
    if (role == kUserRoleAdmin) {
        //add button for all trips
        UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        UIBarButtonItem *calendarButton=[[UIBarButtonItem alloc] initWithTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-list-alt"] style:UIBarButtonItemStylePlain target:self action:@selector(showCalendar)];
        [calendarButton setTitleTextAttributes:@{
                                                 NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:24.0],
                                                 NSForegroundColorAttributeName: self.view.tintColor
                                                 } forState:UIControlStateNormal];
        NSMutableArray *newItems = [self.toolbarItems mutableCopy];
        [newItems addObject:calendarButton];
        [newItems addObject:flexibleItem];
        [self setToolbarItems:newItems];
    }
}

#pragma mark - IBActions
- (void) showCalendar{
    self.showAllTrips = YES;
    [self performSegueWithIdentifier:@"showTripsOfUser" sender:self];
}

- (IBAction)logoutAction:(id)sender {
    id<LogoutHandlerProtocol> handler = (id<LogoutHandlerProtocol>)[[UIApplication sharedApplication] delegate];
    [handler logoutUser];
}

- (IBAction)addEntryAction:(id)sender{
    [self performSegueWithIdentifier:@"presentLoginView" sender:self];
}


- (IBAction)unwindToUserController:(UIStoryboardSegue *)segue {
    //trip detail calls this when exits
}
@end
