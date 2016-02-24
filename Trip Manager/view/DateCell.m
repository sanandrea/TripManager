//
//  DateCell.m
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "DateCell.h"

@implementation DateCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.dateLabel.text = self.isStartDate ? NSLocalizedString(@"Start Date", @"Start date label cell"): NSLocalizedString(@"End Date", @"End date label cell");
    // Configure the view for the selected state
}

- (NSDictionary*) getKeyValueCouple{
    NSString *key = self.isStartDate ? @"startdate" : @"enddate";
    return @{key : self.date};
}
- (void) customizeWithData:(Trip*) trip{
    self.date = (self.isStartDate) ? trip.startdate : trip.enddate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateValue.text = [dateFormatter stringFromDate:self.date];
}

@end
