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

    // Configure the view for the selected state
}

- (NSDictionary*) getKeyValueCouple{
    NSString *key = self.isStartDate ? @"startdate" : @"enddate";
    return @{key : self.dateValue.text};
}

@end
