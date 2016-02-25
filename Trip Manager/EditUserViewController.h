//
//  EditUserViewController.h
//  Trip Manager
//
//  Created by Andi Palo on 25/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Customer.h"
#import "APConstants.h"


@interface EditUserViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *usernameLabel;
@property (weak, nonatomic) IBOutlet UITextField *usernameValue;
@property (weak, nonatomic) IBOutlet UILabel *roleLabel;
@property (weak, nonatomic) IBOutlet UILabel *roleValue;
@property (weak, nonatomic) IBOutlet UIButton *promote;
- (IBAction)promoteAction:(id)sender;

@property (strong, nonatomic) Customer* customer;

@end
