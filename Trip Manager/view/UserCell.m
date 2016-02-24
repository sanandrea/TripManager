//
//  UserCell.m
//  Trip Manager
//
//  Created by Andi Palo on 24/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import "UserCell.h"

@implementation UserCell


- (void)awakeFromNib {
    // Initialization code
    self.userRoleLabel.text = NSLocalizedString(@"Role", @"Role of user");
    
}

@end
