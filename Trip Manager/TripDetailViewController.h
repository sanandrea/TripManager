//
//  TripDetailViewController.h
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"
#import "APConstants.h"

@interface TripDetailViewController : UITableViewController

@property (nonatomic) BOOL isEditMode;
@property (strong, nonatomic) Trip* trip;

@end
