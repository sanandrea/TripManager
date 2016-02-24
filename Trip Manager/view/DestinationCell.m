//
//  DestinationCell.m
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "DestinationCell.h"

@implementation DestinationCell

- (void)awakeFromNib {
    // Initialization code
    self.destination.text = NSLocalizedString(@"Destination", @"destination label cell");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSDictionary*) getKeyValueCouple{
    return @{@"destination": self.destinationValue.text};
}

- (void) customizeWithData:(Trip*) trip{
    self.destinationValue.text = trip.destination;
}

@end
