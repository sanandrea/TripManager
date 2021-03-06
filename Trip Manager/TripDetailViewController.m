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
//  TripDetailViewController.m
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "TripDetailViewController.h"
#import "CellDataProvider.h"

//custom cells
#import "CommentCell.h"
#import "DateCell.h"
#import "DestinationCell.h"

#define kPickerAnimationDuration    0.40   // duration for the animation to slide the date picker into view
#define kDatePickerTag              99     // view tag identifiying the date picker view


// keep track of which rows have date cells
#define kDateStartRow   1
#define kDateEndRow     2

static NSString *kDestinationCell = @"destinationCell";     // the remaining cells at the end
static NSString *kDateCellID = @"dateCell";     // the cells with the start or end date
static NSString *kDatePickerID = @"datePicker"; // the cell containing the date picker
static NSString *kCommentCell = @"commentCell";     // the remaining cells at the end


#pragma mark -

@interface TripDetailViewController ()

@property (nonatomic, strong) NSDateFormatter *dateFormatter;

// keep track which indexPath points to the cell with UIDatePicker
@property (nonatomic, strong) NSIndexPath *datePickerIndexPath;

@property (assign) NSInteger pickerCellRowHeight;

@property (nonatomic, strong) IBOutlet UIDatePicker *pickerView;

@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSDate *endDate;

@end


#pragma mark -

@implementation TripDetailViewController

/*! Primary view has been loaded for this view controller
 */
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [self.dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    // obtain the picker view cell's height, works because the cell was pre-defined in our storyboard
    UITableViewCell *pickerViewCellToCheck = [self.tableView dequeueReusableCellWithIdentifier:kDatePickerID];
    self.pickerCellRowHeight = CGRectGetHeight(pickerViewCellToCheck.frame);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]
                                   initWithTarget:self
                                   action:@selector(dismissKeyboard)];
    
    [tap setCancelsTouchesInView:NO];
    [self.view addGestureRecognizer:tap];
    
    // if the local changes while in the background, we need to be notified so we can update the date
    // format in the table view cells
    //
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(localeChanged:)
                                                 name:NSCurrentLocaleDidChangeNotification
                                               object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:NSCurrentLocaleDidChangeNotification
                                                  object:nil];
}
- (void) dismissKeyboard
{
    [self.view endEditing:YES];
}

#pragma mark - Locale

/*! Responds to region format or locale changes.
 */
- (void)localeChanged:(NSNotification *)notif
{
    // the user changed the locale (region format) in Settings, so we are notified here to
    // update the date format in the table view cells
    //
    [self.tableView reloadData];
}



/*! Determines if the given indexPath has a cell below it with a UIDatePicker.
 
 @param indexPath The indexPath to check if its cell has a UIDatePicker below it.
 */
- (BOOL)hasPickerForIndexPath:(NSIndexPath *)indexPath
{
    BOOL hasDatePicker = NO;
    
    NSInteger targetedRow = indexPath.row;
    targetedRow++;
    
    UITableViewCell *checkDatePickerCell =
        [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:targetedRow inSection:0]];
    UIDatePicker *checkDatePicker = (UIDatePicker *)[checkDatePickerCell viewWithTag:kDatePickerTag];
    
    hasDatePicker = (checkDatePicker != nil);
    return hasDatePicker;
}

/*! Updates the UIDatePicker's value to match with the date of the cell above it.
 */
- (void)updateDatePicker
{
    if (self.datePickerIndexPath != nil)
    {
        NSIndexPath *sourceIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
        UITableViewCell *associatedDatePickerCell = [self.tableView cellForRowAtIndexPath:self.datePickerIndexPath];
        
        UIDatePicker *targetedDatePicker = (UIDatePicker *)[associatedDatePickerCell viewWithTag:kDatePickerTag];
        
        if (targetedDatePicker != nil){
            UITableViewCell *sourceCell = (UITableViewCell*)[self.tableView cellForRowAtIndexPath:sourceIndexPath];
            if ([sourceCell isKindOfClass:[DateCell class]]) {
                DateCell *cell = (DateCell*)sourceCell;
                if(cell.date != nil){
                    [targetedDatePicker setDate:cell.date animated:NO];
                }
            }
        }
    }
}

/*! Determines if the UITableViewController has a UIDatePicker in any of its cells.
 */
- (BOOL)hasInlineDatePicker
{
    return (self.datePickerIndexPath != nil);
}

/*! Determines if the given indexPath points to a cell that contains the UIDatePicker.
 
 @param indexPath The indexPath to check if it represents a cell with the UIDatePicker.
 */
- (BOOL)indexPathHasPicker:(NSIndexPath *)indexPath
{
    return ([self hasInlineDatePicker] && self.datePickerIndexPath.row == indexPath.row);
}

/*! Determines if the given indexPath points to a cell that contains the start/end dates.
 
    @param indexPath The indexPath to check if it represents start/end date cell.
*/
- (BOOL)indexPathHasDate:(NSIndexPath *)indexPath
{
    BOOL hasDate = NO;
    
    if ((indexPath.row == kDateStartRow) ||
        (indexPath.row == kDateEndRow || ([self hasInlineDatePicker] && (indexPath.row == kDateEndRow + 1))))
    {
        hasDate = YES;
    }
    
    return hasDate;
}
#pragma mark - Utility

- (NSString*) cellIdentifierForIndexPath:(NSIndexPath*)indexPath{
    NSInteger row = [indexPath row];
    if ([self indexPathHasPicker:indexPath]){
        // the indexPath is the one containing the inline date picker
        return kDatePickerID;     // the current/opened date picker cell
    }
    if (row == 0){
        return kDestinationCell;
    }
    if ([self hasInlineDatePicker]) {
        if (self.datePickerIndexPath.row > row) {
            return kDateCellID;
        }else if (row == 4){
            return kCommentCell;
        }else if (row == 3){
            return kDateCellID;
        }
    }else{
        if (row == 1 || row == 2){
            return kDateCellID;
        }else if (row == 3){
            return kCommentCell;
        }
    }
    
    return @"";
}

#pragma mark - UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ([self indexPathHasPicker:indexPath] ? self.pickerCellRowHeight : self.tableView.rowHeight);
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self hasInlineDatePicker] ? 5 : 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = nil;

    NSString *cellID = [self cellIdentifierForIndexPath:indexPath];
    

    cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    if ([cellID isEqualToString:kDateCellID]) {
        if ([indexPath row] == 1) {
            ((DateCell*)cell).isStartDate = YES;
        }else{
            ((DateCell*)cell).isStartDate = NO;
        }
    }
    
    
    if ([cell respondsToSelector:@selector(customizeWithData:)] && self.isEditMode) {
        [((id<CellDataProvider>)cell) customizeWithData:self.trip];
    }
    
	return cell;
}

/*! Adds or removes a UIDatePicker cell below the given indexPath.
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)toggleDatePickerForSelectedIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView beginUpdates];
    
    NSArray *indexPaths = @[[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:0]];
                            
    // check if 'indexPath' has an attached date picker below it
    if ([self hasPickerForIndexPath:indexPath])
    {
        // found a picker below it, so remove it
        [self.tableView deleteRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    else
    {
        // didn't find a picker below it, so we should insert it
        [self.tableView insertRowsAtIndexPaths:indexPaths
                              withRowAnimation:UITableViewRowAnimationFade];
    }
    
    [self.tableView endUpdates];
}

/*! Reveals the date picker inline for the given indexPath, called by "didSelectRowAtIndexPath".
 
 @param indexPath The indexPath to reveal the UIDatePicker.
 */
- (void)displayInlineDatePickerForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // display the date picker inline with the table content
    [self.tableView beginUpdates];
    
    BOOL before = NO;   // indicates if the date picker is below "indexPath", help us determine which row to reveal
    if ([self hasInlineDatePicker])
    {
        before = self.datePickerIndexPath.row < indexPath.row;
        
        //check start end date only when "closing picker"
        if (self.endDate != nil && self.startDate != nil) {
            if ([self.endDate compare:self.startDate] == NSOrderedAscending) {
                [self displayErrorWithMessage:NSLocalizedString(@"Start Date after End Date", @"Error message")
                                     andTitle:NSLocalizedString(@"Data error", @"Error title")];
                // always deselect the row containing the start or end date
                [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                [self.tableView endUpdates];
                return;
            }
        }
        
    }
    
    BOOL sameCellClicked = (self.datePickerIndexPath.row - 1 == indexPath.row);
    
    // remove any date picker cell if it exists
    if ([self hasInlineDatePicker])
    {
        [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.datePickerIndexPath.row inSection:0]]
                              withRowAnimation:UITableViewRowAnimationFade];
        self.datePickerIndexPath = nil;
    }
    
    if (!sameCellClicked)
    {
        // hide the old date picker and display the new one
        NSInteger rowToReveal = (before ? indexPath.row - 1 : indexPath.row);
        NSIndexPath *indexPathToReveal = [NSIndexPath indexPathForRow:rowToReveal inSection:0];
        
        [self toggleDatePickerForSelectedIndexPath:indexPathToReveal];
        self.datePickerIndexPath = [NSIndexPath indexPathForRow:indexPathToReveal.row + 1 inSection:0];
    }
    
    // always deselect the row containing the start or end date
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self.tableView endUpdates];
    
    // inform our date picker of the current date to match the current cell
    [self updateDatePicker];
}



- (void)displayErrorWithMessage:(NSString*)msg andTitle:(NSString*)title{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:title
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {
                                                          }];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (cell.reuseIdentifier == kDateCellID)
    {
        [self displayInlineDatePickerForRowAtIndexPath:indexPath];
    }
    else
    {
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}


#pragma mark - Actions

/*! User chose to change the date by changing the values inside the UIDatePicker.
 
 @param sender The sender for this action: UIDatePicker.
 */
- (IBAction)dateAction:(id)sender
{
    NSIndexPath *targetedCellIndexPath = nil;
    
    if ([self hasInlineDatePicker])
    {
        // inline date picker: update the cell's date "above" the date picker cell
        //
        targetedCellIndexPath = [NSIndexPath indexPathForRow:self.datePickerIndexPath.row - 1 inSection:0];
    }
    
    DateCell *cell = (DateCell*) [self.tableView cellForRowAtIndexPath:targetedCellIndexPath];
    UIDatePicker *targetedDatePicker = sender;
    
    if ([targetedCellIndexPath row] == 1) {
        self.startDate = targetedDatePicker.date;
        
    }else{
        self.endDate = targetedDatePicker.date;
    }
    
    // update the cell's date string
    cell.dateValue.text = [self.dateFormatter stringFromDate:targetedDatePicker.date];
    cell.date = targetedDatePicker.date;
}


- (IBAction)saveTrip:(id)sender {
    if (self.trip == nil) {
        // add a new model
        TripRepository *trepo = (TripRepository*)[[[APConstants sharedInstance] getCurrentAdapter] repositoryWithClass:[TripRepository class]];
        self.trip = (Trip*)[trepo model];
    }
    
    for (UITableViewCell *cell in self.tableView.visibleCells){
        if ([cell respondsToSelector:@selector(getKeyValueCouple)]) {
            id<CellDataProvider> f = (id<CellDataProvider>)cell;
            NSDictionary *currentEntry = [f getKeyValueCouple];
            for (NSString *key in currentEntry) {
                if (currentEntry[key] == [NSNull null]) {
                    NSString *msg = [NSString stringWithFormat:@"Could not save trip, field %@ is empty",key];
                    [self displayErrorWithMessage:NSLocalizedString(msg, @"Empty data on trip message")
                                         andTitle:NSLocalizedString(@"Save Error", @"Error title")];
                    return;
                }
                [self.trip setValue:currentEntry[key] forKey:key];
            }
        }
    }
    [self.trip saveWithSuccess:^(){
        [self performSegueWithIdentifier:@"unwindToMasterC" sender:self];
    } failure:^(NSError *error){
        [self displayErrorWithMessage:[error localizedDescription]
                             andTitle:NSLocalizedString(@"Service Error", @"Server Error")];
    }];
}
@end

