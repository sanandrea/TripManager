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
    return self.date != nil ? @{key: self.date} : @{key: [NSNull null]};
}
- (void) customizeWithData:(Trip*) trip{
    self.date = (self.isStartDate) ? trip.startdate : trip.enddate;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];    // show short-style date format
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    self.dateValue.text = [dateFormatter stringFromDate:self.date];
}

@end
