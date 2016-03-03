//
//  CommentCell.m
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "CommentCell.h"

@implementation CommentCell

- (void)awakeFromNib {
    // Initialization code
    self.comment.text = NSLocalizedString(@"Comment", @"Comment label cell");
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSDictionary*) getKeyValueCouple{
    return [self.commentValue.text length] > 0 ? @{@"comment": self.commentValue.text} : @{@"comment": [NSNull null]};
}
- (void) customizeWithData:(Trip*) trip{
    self.commentValue.text = trip.comment;
}


@end
