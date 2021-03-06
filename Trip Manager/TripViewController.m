// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
// 
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
// 
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
// 
//
//  Copyright © 2016 Andi Palo
//  This file is part of project: TripManager
//
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
#import "TripCell.h"
#import "Customer.h"
#import "NSDate+TimeAgo.h"
#import "PdfCreator.h"

#import <QuartzCore/QuartzCore.h>

const int DAY_SECONDS = 86400;

@interface TripViewController ()
@property (strong, nonatomic) NSMutableArray* trips;
@property (strong, nonatomic) Trip *selectedTrip;
@property (strong, nonatomic) NSDateFormatter *dateFormatter;
@property (strong, nonatomic) UISearchController *searchController;
@property (nonatomic, strong) NSArray *filteredTrips;
@property (strong, nonatomic) UIDocumentInteractionController *documentInteractionController;
@end

@implementation TripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Trips";
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    self.tableView.allowsSelectionDuringEditing = YES;
    
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    [self customizeToolbar];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    NSLocale *enUSPOSIXLocale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    [self.dateFormatter setLocale:enUSPOSIXLocale];
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];

    self.searchController.searchResultsUpdater = self;
    self.searchController.dimsBackgroundDuringPresentation = false;
    self.searchController.searchBar.delegate = self;
    self.definesPresentationContext = true;
    
    self.searchController.searchBar.scopeButtonTitles = @[@"All", @"Destination", @"Comment"];
    self.tableView.tableHeaderView = self.searchController.searchBar;

}

-(void) viewWillAppear:(BOOL)animated{
    self.clearsSelectionOnViewWillAppear = self.splitViewController.isCollapsed;
    [super viewWillAppear:animated];
    self.selectedTrip = nil;
    
    if (self.showAlltrips) {
        LBRESTAdapter *adapter = (LBRESTAdapter*) [[APConstants sharedInstance] getCurrentAdapter];
        TripRepository *trepo = (TripRepository*) [adapter repositoryWithClass:[TripRepository class]];
        NSDictionary *parameters = @{@"filter":@{@"include":@"customer"}};
        
        [trepo invokeStaticMethod:@"list-all" parameters:parameters success:^(id value){
            self.trips = [NSMutableArray arrayWithArray:(NSArray*)value];
            self.filteredTrips = [NSMutableArray arrayWithCapacity:[self.trips count]];
            [self.tableView reloadData];
        } failure:CALLBACK_FAILURE_BLOCK];
        
    }else{
        CustomerRepository *crepo = (CustomerRepository*)[[APConstants sharedInstance] getCustomerRepository];
        NSString *userId = (self.userId == nil) ? crepo.currentUserId : self.userId;
        [crepo findCurrentUserWithSuccess:^(LBUser *user){
            NSDictionary *parameters = @{@"id" : userId,@"filter":@{@"include":@"customer"}};
            
            [crepo invokeStaticMethod:@"trip-list" parameters:parameters success:^(id value){
                self.trips = [NSMutableArray arrayWithArray:(NSArray*)value];
                self.filteredTrips = [NSMutableArray arrayWithCapacity:[self.trips count]];
                [self.tableView reloadData];
            }failure:CALLBACK_FAILURE_BLOCK];
        } failure:CALLBACK_FAILURE_BLOCK];
    }
}

-(void)dealloc {
    [self.searchController.view removeFromSuperview]; // It works! http://stackoverflow.com/questions/32282401
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.searchController.isActive && [self.searchController.searchBar.text length] > 0) {
        return [self.filteredTrips count];
    }
    
    return [self.trips count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TripCell *cell = (TripCell*)[tableView dequeueReusableCellWithIdentifier:@"tripCell"
                                                                forIndexPath:indexPath];
    
    NSDictionary *cellData;
    if (self.searchController.isActive && [self.searchController.searchBar.text length] > 0){
        cellData = [self.filteredTrips objectAtIndex:[indexPath row]];
    }else{
        cellData = [self.trips objectAtIndex:[indexPath row]];
    }
    
    cell.destination.text = cellData[@"destination"];
    
    NSDate *startDate = [self.dateFormatter dateFromString:cellData[@"startdate"]];
    NSTimeInterval interval = [startDate timeIntervalSinceNow];
    int days = (int)interval/DAY_SECONDS;
    if (interval > 0) {
        cell.futureCounter.text = [NSString stringWithFormat:@"Starts in %d day%@",days,days == 1 ? @"" :@"s" ];
    }else{
        cell.futureCounter.text = [startDate timeAgo];
    }
    
    if (self.userId == nil) {
        cell.userIcon.hidden = YES;
        cell.userName.hidden = YES;
    }else{
        cell.userIcon.font = [UIFont fontWithName:kFontAwesomeFamilyName size:20];
        cell.userIcon.text = [NSString fontAwesomeIconStringForEnum:FAUser];
        cell.userName.text = cellData[@"customer"][@"username"];
        
    }

    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *info;
    if (self.searchController.isActive && [self.searchController.searchBar.text length] > 0){
        info = [self.filteredTrips objectAtIndex:[indexPath row]];
    }else{
        info = [self.trips objectAtIndex:[indexPath row]];
    }

    TripRepository *trepo = (TripRepository*)[[[APConstants sharedInstance] getCurrentAdapter] repositoryWithClass:[TripRepository class]];
    self.selectedTrip = (Trip*)[trepo modelWithDictionary:info];
    [self performSegueWithIdentifier:@"showTripInfo" sender:self];
    
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        NSDictionary *toDelete = (NSDictionary*)[self.trips objectAtIndex:[indexPath row]];
        LBRESTAdapter *adapter = (LBRESTAdapter*) [[APConstants sharedInstance] getCurrentAdapter];
        TripRepository *trepo = (TripRepository*) [adapter repositoryWithClass:[TripRepository class]];
        Trip *trip = (Trip*)[trepo modelWithDictionary:toDelete];
        [trip destroyWithSuccess:^{
            [self.trips removeObject:toDelete];
            [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        } failure:CALLBACK_FAILURE_BLOCK];
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
    self.logout.isAccessibilityElement = YES;
    [self.addEntry setTitleTextAttributes:@{
                                               NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:24.0],
                                               NSForegroundColorAttributeName: self.view.tintColor
                                               } forState:UIControlStateNormal];
    [self.addEntry setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-plus"]];
    self.addEntry.isAccessibilityElement = YES;
    [self.planner setTitleTextAttributes:@{
                                           NSFontAttributeName: [UIFont fontWithName:@"FontAwesome" size:24.0],
                                           NSForegroundColorAttributeName: self.view.tintColor
                                           } forState:UIControlStateNormal];
    [self.planner setTitle:[NSString fontAwesomeIconStringForIconIdentifier:@"fa-calendar"]];
    self.planner.isAccessibilityElement = YES;
}

#pragma mark - Filtering
- (void)filterContentForSearchText:(NSString*) text inScope:(NSString*)scope{
    NSString *predString;
    if ([scope isEqualToString:@"All"]) {
        predString = [NSString stringWithFormat:@"(destination contains[c] '%@') OR (comment contains[c] '%@')", text,text];
    }else{
        predString = [NSString stringWithFormat:@"(%@ contains[cd] '%@')", [scope lowercaseString],text];
    }
    NSPredicate *pred = [NSPredicate predicateWithFormat:predString];
    self.filteredTrips = [self.trips filteredArrayUsingPredicate:pred];
    [self.tableView reloadData];
}
- (void) updateSearchResultsForSearchController:(UISearchController *)searchController{
    NSString *text = searchController.searchBar.text;
    NSString *scope = [searchController.searchBar.scopeButtonTitles objectAtIndex:searchController.searchBar.selectedScopeButtonIndex];
    [self filterContentForSearchText:text inScope:scope];
}

- (void)searchBar:(UISearchBar *)searchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope{
    [self filterContentForSearchText:searchBar.text inScope:[searchBar.scopeButtonTitles objectAtIndex:selectedScope]];
}

#pragma mark - IBActions
- (IBAction)logoutAction:(id)sender {
    id<LogoutHandlerProtocol> handler = (id<LogoutHandlerProtocol>)[[UIApplication sharedApplication] delegate];
    [handler logoutUser];
}

- (IBAction)addAction:(id)sender {
    [self performSegueWithIdentifier:@"showTripInfo" sender:self];
}

- (IBAction)plannerAction:(id)sender {
    [self generateAndViewPDF];
}

- (IBAction)unwindToMasterC:(UIStoryboardSegue *)segue {
    //trip detail calls this when exits
}

#pragma mark - planner

- (void) generateAndViewPDF{
    // Retrieves the document directories from the iOS device
    NSArray* documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask,YES);
    
    NSString* documentDirectory = [documentDirectories objectAtIndex:0];
    NSString* documentDirectoryFilename = [documentDirectory stringByAppendingPathComponent:@"plan.pdf"];
    
    NSLog(@"documentDirectoryFileName: %@",documentDirectoryFilename);
    
    PdfCreator *pdf = [[PdfCreator alloc] init];
    [pdf createPdfWithName:documentDirectoryFilename];
    
    
    
    //filter array only for next month
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDate *today = [NSDate date];
    NSPredicate *nextMonth = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSDate *start = [self.dateFormatter dateFromString:[evaluatedObject valueForKey:@"startdate"]];
        NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitDay
                                                            fromDate:today
                                                              toDate:start
                                                             options:NSCalendarWrapComponents];
        return [components day] < 30 && [components day] > 0;
        
        
    }];
    
    
    NSArray *nextMonthTrips = [self.trips filteredArrayUsingPredicate:nextMonth];
    
    for (Trip *t in nextMonthTrips) {
        [pdf drawLabelsForTrip:t];
    }
    
    [pdf endFile];
    
    NSURL *URL = [NSURL fileURLWithPath:documentDirectoryFilename];
    
    if (URL) {
        // Initialize Document Interaction Controller
        self.documentInteractionController = [UIDocumentInteractionController interactionControllerWithURL:URL];
        
        // Configure Document Interaction Controller
        [self.documentInteractionController setDelegate:self];
        
        // Preview PDF
        [self.documentInteractionController presentPreviewAnimated:YES];
    }
}

#pragma mark - Document interactions
- (UIViewController *) documentInteractionControllerViewControllerForPreview: (UIDocumentInteractionController *) controller {
    return self.navigationController;
}

@end
