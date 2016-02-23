//
//  TripCell.h
//  Trip Manager
//
//  Created by Andi Palo on 23/02/16.
//  Copyright © 2016 Andi Palo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Trip.h"

@interface TripCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *destination;
@property (strong, nonatomic) IBOutlet UILabel *futureCounter;
@property (strong, nonatomic) IBOutlet UILabel *userIcon;
@property (strong, nonatomic) IBOutlet UILabel *userName;

@property (strong, nonatomic) Trip *myTrip;

@end
