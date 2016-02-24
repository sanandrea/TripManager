//
//  UserCell.h
//  Trip Manager
//
//  Created by Andi Palo on 24/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UILabel *userRoleLabel;
@property (weak, nonatomic) IBOutlet UILabel *userRoleValue;

@end
