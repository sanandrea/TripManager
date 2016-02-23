//
//  TripViewController.h
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TripViewController : UITableViewController
@property (strong,nonatomic) IBOutlet UIBarButtonItem *planner;
@property (strong,nonatomic) IBOutlet UIBarButtonItem *logout;
@property (strong,nonatomic) IBOutlet UIBarButtonItem *editEntries;

- (IBAction)logoutAction:(id)sender;
- (IBAction)editAction:(id)sender;
- (IBAction)plannerAction:(id)sender;


@end
